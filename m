Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2CF11C134
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Dec 2019 01:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbfLLAO5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Dec 2019 19:14:57 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37845 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727162AbfLLAO5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Dec 2019 19:14:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576109695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AnwvV3JcXu6OoSRcbxUU5otWwQPlOeB+qnbHA7Fs6fE=;
        b=PsdTHT+F+XujokVKtxUgXf8jGjvpCWQ+NRSldoUJsdKj2LFKbcGui61BKOuJoswouBnjy6
        hHpH9gDLU/3LwrieL/86h6loFBy0UC4p3ANgJSuPQMfP8Syhs+Nb7aMGlByAcbNqSPu952
        g2b4PjGG7v1PGGXX/qS4UDH5mGPtZrY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-3hUmC3peML-HwOSPNdbOOA-1; Wed, 11 Dec 2019 19:14:54 -0500
X-MC-Unique: 3hUmC3peML-HwOSPNdbOOA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A652C477;
        Thu, 12 Dec 2019 00:14:53 +0000 (UTC)
Received: from [10.72.12.38] (ovpn-12-38.pek2.redhat.com [10.72.12.38])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 68C6219C69;
        Thu, 12 Dec 2019 00:14:49 +0000 (UTC)
Subject: Re: [PATCH v3] ceph: check availability of mds cluster on mount after
 wait timeout
To:     Jeff Layton <jlayton@kernel.org>
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20191211012940.18128-1-xiubli@redhat.com>
 <f1ef6025423394c7976df367673244b06dd83dc8.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <8ec22833-37d8-73d4-4415-b8af4b9420f2@redhat.com>
Date:   Thu, 12 Dec 2019 08:14:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <f1ef6025423394c7976df367673244b06dd83dc8.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019/12/11 21:17, Jeff Layton wrote:
> On Tue, 2019-12-10 at 20:29 -0500, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> If all the MDS daemons are down for some reasons and for the first
>> time to do the mount, it will fail with IO error after the mount
>> request timed out.
>>
>> Or if the cluster becomes laggy suddenly, and just before the kclient
>> getting the new mdsmap and the mount request is fired off, it also
>> will fail with IO error.
>>
>> This will add some useful hint message by checking the cluster state
>> before the fail the mount operation.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> V3:
>> - Rebase to the new mount API version.
>>
>>   fs/ceph/mds_client.c | 3 +--
>>   fs/ceph/super.c      | 5 +++++
>>   2 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 7d3ec051f179..bf507120659e 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -2576,8 +2576,7 @@ static void __do_request(struct ceph_mds_client *mdsc,
>>   		if (!(mdsc->fsc->mount_options->flags &
>>   		      CEPH_MOUNT_OPT_MOUNTWAIT) &&
>>   		    !ceph_mdsmap_is_cluster_available(mdsc->mdsmap)) {
>> -			err = -ENOENT;
>> -			pr_info("probably no mds server is up\n");
>> +			err = -EHOSTUNREACH;
>>   			goto finish;
>>   		}
>>   	}
>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>> index 9c9a7c68eea3..6f33a265ccf1 100644
>> --- a/fs/ceph/super.c
>> +++ b/fs/ceph/super.c
>> @@ -1068,6 +1068,11 @@ static int ceph_get_tree(struct fs_context *fc)
>>   	return 0;
>>   
>>   out_splat:
>> +	if (!ceph_mdsmap_is_cluster_available(fsc->mdsc->mdsmap)) {
>> +		pr_info("No mds server is up or the cluster is laggy\n");
>> +		err = -EHOSTUNREACH;
>> +	}
>> +
>>   	ceph_mdsc_close_sessions(fsc->mdsc);
>>   	deactivate_locked_super(sb);
>>   	goto out_final;
> Looks reasonable. Merged into testing branch with a revamped changelog.
> Please have a look at the testing branch and make sure the changelog is
> OK with you.

Yeah, that looks good to me.

Thanks.


>
> Thanks,


