Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7432211C131
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Dec 2019 01:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfLLAOH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Dec 2019 19:14:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30495 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727067AbfLLAOH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 11 Dec 2019 19:14:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576109645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XICnWQaiUBBG1XauQbfJg1keusmB4syqQCaVOINJsjI=;
        b=SCYFuXTH6AaIi8AmrWYjxM9F/0hm/HSrU6LTrU82Osj6BcAh/L3eUpMyvofHPnY6VVloTe
        UYZNpnId419h7IC3ITkLZDrQnsesVR0SWAMr3mTObEdrxnKStCPl8Ffzd9lt1yQ+Kq4XjL
        MuTyLHPK3aLm3gKskRqnmL8xxf7bIk8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-w50LnrxLPjSJ0wh2RPFPeQ-1; Wed, 11 Dec 2019 19:14:03 -0500
X-MC-Unique: w50LnrxLPjSJ0wh2RPFPeQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3F43800EC0;
        Thu, 12 Dec 2019 00:14:02 +0000 (UTC)
Received: from [10.72.12.38] (ovpn-12-38.pek2.redhat.com [10.72.12.38])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B9F846E6C;
        Thu, 12 Dec 2019 00:13:58 +0000 (UTC)
Subject: Re: [PATCH] ceph: retry the same mds later after the new session is
 opened
To:     Jeff Layton <jlayton@kernel.org>
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20191209124715.2255-1-xiubli@redhat.com>
 <1dccc3cc4a622547df0da814763634d42070cbad.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <e17d7374-f8f3-b07c-d86c-dd2ed5653539@redhat.com>
Date:   Thu, 12 Dec 2019 08:13:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <1dccc3cc4a622547df0da814763634d42070cbad.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019/12/11 21:41, Jeff Layton wrote:
> On Mon, 2019-12-09 at 07:47 -0500, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> With max_mds > 1 and for a request which are choosing a random
>> mds rank and if the relating session is not opened yet, the request
>> will wait the session been opened and resend again. While every
>> time the request is beening __do_request, it will release the
>> req->session first and choose a random one again, so this time it
>> may choose another random mds rank. The worst case is that it will
>> open all the mds sessions one by one just before it can be
>> successfully sent out out.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c | 20 ++++++++++++++++----
>>   1 file changed, 16 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 68f3b5ed6ac8..d747e9baf9c9 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -876,7 +876,8 @@ static struct inode *get_nonsnap_parent(struct dentry *dentry)
>>    * Called under mdsc->mutex.
>>    */
>>   static int __choose_mds(struct ceph_mds_client *mdsc,
>> -			struct ceph_mds_request *req)
>> +			struct ceph_mds_request *req,
>> +			bool *random)
>>   {
>>   	struct inode *inode;
>>   	struct ceph_inode_info *ci;
>> @@ -886,6 +887,9 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
>>   	u32 hash = req->r_direct_hash;
>>   	bool is_hash = test_bit(CEPH_MDS_R_DIRECT_IS_HASH, &req->r_req_flags);
>>   
>> +	if (random)
>> +		*random = false;
>> +
>>   	/*
>>   	 * is there a specific mds we should try?  ignore hint if we have
>>   	 * no session and the mds is not up (active or recovering).
>> @@ -1021,6 +1025,9 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
>>   	return mds;
>>   
>>   random:
>> +	if (random)
>> +		*random = true;
>> +
>>   	mds = ceph_mdsmap_get_random_mds(mdsc->mdsmap);
>>   	dout("choose_mds chose random mds%d\n", mds);
>>   	return mds;
>> @@ -2556,6 +2563,7 @@ static void __do_request(struct ceph_mds_client *mdsc,
>>   	struct ceph_mds_session *session = NULL;
>>   	int mds = -1;
>>   	int err = 0;
>> +	bool random;
>>   
>>   	if (req->r_err || test_bit(CEPH_MDS_R_GOT_RESULT, &req->r_req_flags)) {
>>   		if (test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags))
>> @@ -2596,7 +2604,7 @@ static void __do_request(struct ceph_mds_client *mdsc,
>>   
>>   	put_request_session(req);
>>   
>> -	mds = __choose_mds(mdsc, req);
>> +	mds = __choose_mds(mdsc, req, &random);
>>   	if (mds < 0 ||
>>   	    ceph_mdsmap_get_state(mdsc->mdsmap, mds) < CEPH_MDS_STATE_ACTIVE) {
>>   		dout("do_request no mds or not active, waiting for map\n");
>> @@ -2624,8 +2632,12 @@ static void __do_request(struct ceph_mds_client *mdsc,
>>   			goto out_session;
>>   		}
>>   		if (session->s_state == CEPH_MDS_SESSION_NEW ||
>> -		    session->s_state == CEPH_MDS_SESSION_CLOSING)
>> +		    session->s_state == CEPH_MDS_SESSION_CLOSING) {
>>   			__open_session(mdsc, session);
>> +			/* retry the same mds later */
>> +			if (random)
>> +				req->r_resend_mds = mds;
>> +		}
>>   		list_add(&req->r_wait, &session->s_waiting);
>>   		goto out_session;
>>   	}
>> @@ -2890,7 +2902,7 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
>>   			mutex_unlock(&mdsc->mutex);
>>   			goto out;
>>   		} else  {
>> -			int mds = __choose_mds(mdsc, req);
>> +			int mds = __choose_mds(mdsc, req, NULL);
>>   			if (mds >= 0 && mds != req->r_session->s_mds) {
>>   				dout("but auth changed, so resending\n");
>>   				__do_request(mdsc, req);
> Is there a tracker bug for this?

I created one just now: https://tracker.ceph.com/issues/43270


>
> This does seem like the behavior we'd want. I wish it were a little less
> Rube Goldberg to do this, but this code is already pretty messy so this
> doesn't really make it too much worse.
>
> In any case, merged with a reworded changelog.

Yeah, that's look good.

Someone in the community hit a long time waiting issue when mounting in 
the fuse client, I checked that logs and it seems a similar issue, but 
not very sure yet.

Thanks.

