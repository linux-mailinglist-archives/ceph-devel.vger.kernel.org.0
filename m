Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33A13B8BB5
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Jul 2021 03:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238322AbhGABSx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Jun 2021 21:18:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31616 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238153AbhGABSw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 30 Jun 2021 21:18:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625102182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w4r6hRJILHLImCUrdwYihINsOMzFrg6peVMSmTUn0tU=;
        b=D12E2YIar+kyK7ac4jT6dExR9eMlDdnhh23gElCbCF93LSwEDgcAVPrD7cVcu8Gy/pwL+l
        I+1OSCgEPp+SFox0PpSzFLaDBvXbfwoqfVQCVeelf0LFGgHAssfDvcv/xnCvRah3n5vF6U
        0pHmgLK2JXVD0nxcuW2B0jARA0k2Bqw=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-xPdgpXjKPTeUEiWG2_LElw-1; Wed, 30 Jun 2021 21:16:21 -0400
X-MC-Unique: xPdgpXjKPTeUEiWG2_LElw-1
Received: by mail-pl1-f197.google.com with SMTP id g16-20020a1709028690b029011e9e164a59so1822994plo.23
        for <ceph-devel@vger.kernel.org>; Wed, 30 Jun 2021 18:16:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=w4r6hRJILHLImCUrdwYihINsOMzFrg6peVMSmTUn0tU=;
        b=tXot9V8MxEewGiVEWr+YY22Y5VLz8Wm1fTmq+7vJMtGOAEEfsasD4e40lUucp3JBkp
         zMIRAaDjAQ7CQ1ZMzcY8Qm1j/toPNZfvsJOcoRHBTeNbeWT/UZL9uXaqT9kFz2aRl6Zv
         7MrJ1ZAylrFb0ianI0b30PTdZ75iT9PeE5RWpGAbbZHlRMsVPfya3pJlSBGRWzAvA+mP
         DS1Cl/QiOWGX9+UVrtbJji0+BY4m40I+Wg6RIZwn5NqWZcms9kV4MzRdVuveS5Tzp6nE
         cMF2eKY1MsoHQA/eNMvOdT9Hxnee2hIwzqojvMs3dTVPeJTJapdL8ANnav1V8Bj1kQXi
         mvXw==
X-Gm-Message-State: AOAM532qslvj+fIJs+OexfVLz0pQYc/aao2owEEqMP4I7iCTJ1xRnne4
        kL9MktsRh7YDTyWcko45ardaavsDt/MhSNcv2FA/pR4btDsyvYVxaUsKD0YObNJeQd02KLSmHFR
        TXXZCvNlMgv/1Z6hjs/1fw2UpcA41hECCqTcOaMTHJjwkU94zQsSHEB0I3iLsz90HCI5CnrE=
X-Received: by 2002:a17:90a:348e:: with SMTP id p14mr41542922pjb.151.1625102180475;
        Wed, 30 Jun 2021 18:16:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFtCrXxNzKNby4XVaSZiQrn6hwU3Fx59TkkAVMP66UbrMATCjtxnakf7hWZSjPqygUC7Of6g==
X-Received: by 2002:a17:90a:348e:: with SMTP id p14mr41542896pjb.151.1625102180155;
        Wed, 30 Jun 2021 18:16:20 -0700 (PDT)
Received: from [10.72.12.103] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t2sm22168244pfg.73.2021.06.30.18.16.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 18:16:19 -0700 (PDT)
Subject: Re: [PATCH 4/5] ceph: flush the mdlog before waiting on unsafe reqs
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210629044241.30359-1-xiubli@redhat.com>
 <20210629044241.30359-5-xiubli@redhat.com>
 <b531585184df099e633a4b92e3be23b4b8384253.camel@kernel.org>
 <4f2f6de6-eb1f-1527-de73-2378f262228b@redhat.com>
 <2e8aabad80e166d7c628fde9d820fc5f403e034f.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <379d5257-f182-c455-9675-b199aeb8ce1b@redhat.com>
Date:   Thu, 1 Jul 2021 09:16:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <2e8aabad80e166d7c628fde9d820fc5f403e034f.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/30/21 8:13 PM, Jeff Layton wrote:
> On Wed, 2021-06-30 at 09:26 +0800, Xiubo Li wrote:
>> On 6/29/21 9:25 PM, Jeff Layton wrote:
>>> On Tue, 2021-06-29 at 12:42 +0800, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> For the client requests who will have unsafe and safe replies from
>>>> MDS daemons, in the MDS side the MDS daemons won't flush the mdlog
>>>> (journal log) immediatelly, because they think it's unnecessary.
>>>> That's true for most cases but not all, likes the fsync request.
>>>> The fsync will wait until all the unsafe replied requests to be
>>>> safely replied.
>>>>
>>>> Normally if there have multiple threads or clients are running, the
>>>> whole mdlog in MDS daemons could be flushed in time if any request
>>>> will trigger the mdlog submit thread. So usually we won't experience
>>>> the normal operations will stuck for a long time. But in case there
>>>> has only one client with only thread is running, the stuck phenomenon
>>>> maybe obvious and the worst case it must wait at most 5 seconds to
>>>> wait the mdlog to be flushed by the MDS's tick thread periodically.
>>>>
>>>> This patch will trigger to flush the mdlog in all the MDSes manually
>>>> just before waiting the unsafe requests to finish.
>>>>
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/caps.c | 9 +++++++++
>>>>    1 file changed, 9 insertions(+)
>>>>
>>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>>> index c6a3352a4d52..6e80e4649c7a 100644
>>>> --- a/fs/ceph/caps.c
>>>> +++ b/fs/ceph/caps.c
>>>> @@ -2286,6 +2286,7 @@ static int caps_are_flushed(struct inode *inode, u64 flush_tid)
>>>>     */
>>>>    static int unsafe_request_wait(struct inode *inode)
>>>>    {
>>>> +	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
>>>>    	struct ceph_inode_info *ci = ceph_inode(inode);
>>>>    	struct ceph_mds_request *req1 = NULL, *req2 = NULL;
>>>>    	int ret, err = 0;
>>>> @@ -2305,6 +2306,14 @@ static int unsafe_request_wait(struct inode *inode)
>>>>    	}
>>>>    	spin_unlock(&ci->i_unsafe_lock);
>>>>    
>>>> +	/*
>>>> +	 * Trigger to flush the journal logs in all the MDSes manually,
>>>> +	 * or in the worst case we must wait at most 5 seconds to wait
>>>> +	 * the journal logs to be flushed by the MDSes periodically.
>>>> +	 */
>>>> +	if (req1 || req2)
>>>> +		flush_mdlog(mdsc);
>>>> +
>>> So this is called on fsync(). Do we really need to flush all of the mds
>>> logs on every fsync? That sounds like it might have some performance
>>> impact. Would it be possible to just flush the mdslog on the MDS that's
>>> authoritative for this inode?
>> I hit one case before, the mds.0 is the auth mds, but the client just
>> sent the request to mds.2, then when the mds.2 tried to gather the
>> rdlocks then it was stuck for waiting for the mds.0 to flush the mdlog.
>> I think it also will happen that if the mds.0 could also be stuck just
>> like this even its the auth MDS.
>>
> It sounds like mds.0 should flush its own mdlog in this situation once
> mds.2 started requesting locks that mds.0 was holding. Shouldn't it?

Yeah, it is. I have fixed this case. I am not sure whether there has 
some other situations just like this.

But they should be bugs in MDS.


>
>> Normally the mdlog submit thread will be triggered per MDS's tick,
>> that's 5 seconds. But this is not always true mostly because any other
>> client request could trigger the mdlog submit thread to run at any time.
>> Since the fsync is not running all the time, so IMO the performance
>> impact should be okay.
>>
>>
> I'm not sure I'm convinced.
>
> Consider a situation where we have a large(ish) ceph cluster with
> several MDSs. One client is writing to a file that is on mds.0 and there
> is little other activity there. Several other clients are doing heavy
> I/O on other inodes (of which mds.1 is auth).
>
> The first client then calls fsync, and now the other clients stall for a
> bit while mds.1 unnecessarily flushes its mdlog. I think we need to take
> care to only flush the mdlog for mds's that we care about here.

Okay, except the above case I mentioned I didn't find any case that 
could prevent us doing this.

Let me test more about it by just flushing the mdlog in auth MDS.

>
>
>>>>    	dout("unsafe_request_wait %p wait on tid %llu %llu\n",
>>>>    	     inode, req1 ? req1->r_tid : 0ULL, req2 ? req2->r_tid : 0ULL);
>>>>    	if (req1) {

