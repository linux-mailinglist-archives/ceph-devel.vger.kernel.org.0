Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3DE64C8D20
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Mar 2022 14:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbiCAN6n (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Mar 2022 08:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiCAN6m (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Mar 2022 08:58:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F2D35D64C
        for <ceph-devel@vger.kernel.org>; Tue,  1 Mar 2022 05:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646143080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OAqthP27kbpQSVl3qsZjF2vmrxeTjKu4qx8rxmV7ESA=;
        b=jRl5UlK1DFVZXpabLFJNZYdkuY2HB87pM1bWZxaliZCTvHNnBCIxHhCaaLlCocRLhUDuuY
        ukbknetzFFVuaXzEfS4todAB2T23+ttCXE2sAp2JXj7JMJB0LAyLHlltQHQN38ZrvEaxSy
        O92eocg9gol3IceHRxwPTCj0/Uww2OU=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-226-YSS4jUdsNMOU8_K-_Kv0pQ-1; Tue, 01 Mar 2022 08:57:59 -0500
X-MC-Unique: YSS4jUdsNMOU8_K-_Kv0pQ-1
Received: by mail-pj1-f70.google.com with SMTP id e7-20020a17090a4a0700b001bc5a8c533eso1682163pjh.4
        for <ceph-devel@vger.kernel.org>; Tue, 01 Mar 2022 05:57:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=OAqthP27kbpQSVl3qsZjF2vmrxeTjKu4qx8rxmV7ESA=;
        b=jPFOWrsuMbNUeYuHzl3OqVPixhqaW5YPnRHKKKrVKZoq21xPdc9f10RzHu3VXL+jtE
         JfXpfWKd6gX+ZoB0zFK8nhcXwM1i41GbUn1cFssxpQM8lgD3jslqGZd3/eTHqZAGi8yy
         IhK72A5aTQWfZfB9d3o93r4f005WopCOUVwxOHkCVcgyr9AkkrCaMwme+xsiZ0NoO98B
         kNh2KQ59vuXjLpqvtEnOgy4pOayroJIwWZn3WSUIjzGxwMJbeAXmCvvqWjUpMS/PKoAm
         0FK2sMFh1ophfPlyda473pqt444MgSg4X4p42Zrm/HC17pmWf05yb5/do8R/C7HPdGxT
         CUzg==
X-Gm-Message-State: AOAM532CTd+8bPPF5mUKC/HsF812JIKuPjK/ajBFHj0yEfjkq0/OVn6r
        UYqvjfFdhH009xzI6w14KLXCsdU5QGnL5BXAyyN6gGBXM6eFE6MzujaKm9N3USykRStL0NI2oB3
        fDE3E8H+rDca6N3qjGssbOaR8idtCCawxmP031Gl/wZ121tJUNZsv9SaEDyNHxbO+FarGGhI=
X-Received: by 2002:a17:902:d508:b0:14f:dd5f:c8b2 with SMTP id b8-20020a170902d50800b0014fdd5fc8b2mr24895732plg.17.1646143078238;
        Tue, 01 Mar 2022 05:57:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyXFhIQdXdldfMI5NfI2qmaF0/pMD/jui5oYFHhn56MHYA9GArdhxtP/JCm9Bqn8Ris6G+VjA==
X-Received: by 2002:a17:902:d508:b0:14f:dd5f:c8b2 with SMTP id b8-20020a170902d50800b0014fdd5fc8b2mr24895700plg.17.1646143077785;
        Tue, 01 Mar 2022 05:57:57 -0800 (PST)
Received: from [10.72.12.114] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r4-20020a17090a438400b001bc6d52de70sm2173449pjg.24.2022.03.01.05.57.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 05:57:57 -0800 (PST)
Subject: Re: [PATCH v2 1/7] ceph: fail the request when failing to decode
 dentry names
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
References: <20220301113015.498041-1-xiubli@redhat.com>
 <20220301113015.498041-2-xiubli@redhat.com>
 <7a75180f14638377db5917d82d0d40c2b86950c7.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <cf767249-821b-590b-425f-1940487201aa@redhat.com>
Date:   Tue, 1 Mar 2022 21:57:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <7a75180f14638377db5917d82d0d40c2b86950c7.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/1/22 9:20 PM, Jeff Layton wrote:
> On Tue, 2022-03-01 at 19:30 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> ------------[ cut here ]------------
>> kernel BUG at fs/ceph/dir.c:537!
>> invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
>> CPU: 16 PID: 21641 Comm: ls Tainted: G            E     5.17.0-rc2+ #92
>> Hardware name: Red Hat RHEV Hypervisor, BIOS 1.11.0-2.el7 04/01/2014
>>
>> The corresponding code in ceph_readdir() is:
>>
>> 	BUG_ON(rde->offset < ctx->pos);
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/dir.c        | 13 +++++++------
>>   fs/ceph/inode.c      |  5 +++--
>>   fs/ceph/mds_client.c |  2 +-
>>   3 files changed, 11 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>> index a449f4a07c07..6be0c1f793c2 100644
>> --- a/fs/ceph/dir.c
>> +++ b/fs/ceph/dir.c
>> @@ -534,6 +534,13 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>>   					    .ctext_len	= rde->altname_len };
>>   		u32 olen = oname.len;
>>   
>> +		err = ceph_fname_to_usr(&fname, &tname, &oname, NULL);
>> +		if (err) {
>> +			pr_err("%s unable to decode %.*s, got %d\n", __func__,
>> +			       rde->name_len, rde->name, err);
>> +			goto out;
>> +		}
>> +
>>   		BUG_ON(rde->offset < ctx->pos);
>>   		BUG_ON(!rde->inode.in);
>>   
>> @@ -542,12 +549,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>>   		     i, rinfo->dir_nr, ctx->pos,
>>   		     rde->name_len, rde->name, &rde->inode.in);
>>   
>> -		err = ceph_fname_to_usr(&fname, &tname, &oname, NULL);
>> -		if (err) {
>> -			dout("Unable to decode %.*s. Skipping it.\n", rde->name_len, rde->name);
>> -			continue;
>> -		}
>> -
>>   		if (!dir_emit(ctx, oname.name, oname.len,
>>   			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
>>   			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>> index 8b0832271fdf..2bc2f02b84e8 100644
>> --- a/fs/ceph/inode.c
>> +++ b/fs/ceph/inode.c
>> @@ -1898,8 +1898,9 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>>   
>>   		err = ceph_fname_to_usr(&fname, &tname, &oname, &is_nokey);
>>   		if (err) {
>> -			dout("Unable to decode %.*s. Skipping it.", rde->name_len, rde->name);
>> -			continue;
>> +			pr_err("%s unable to decode %.*s, got %d\n", __func__,
>> +			       rde->name_len, rde->name, err);
>> +			goto out;
>>   		}
>>   
>
> Is this really an improvement?

Yeah, if we just continue without setting the rde->offset it will crash 
in "BUG_ON(rde->offset < ctx->pos);" in ceph_readdir().


> Suppose I have one dentry with a corrupt
> name. Do I want to fail a readdir request which might allow me to get at
> other dentries in that directory that isn't corrupt?

It's a little hard to handle the code in ceph_readdir():

  503         /* search start position */
  504         if (rinfo->dir_nr > 0) {
  505                 int step, nr = rinfo->dir_nr;
  506                 while (nr > 0) {
  507                         step = nr >> 1;
  508                         if (rinfo->dir_entries[i + step].offset < 
ctx->pos) {
  509                                 i +=  step + 1;
  510                                 nr -= step + 1;
  511                         } else {
  512                                 nr = step;
  513                         }
  514                 }
  515         }

In this case how to set the rde->offset ?


>
> Maybe we should try to emit some placeholder there?
>
>
>>   		dname.name = oname.name;
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 914a6e68bb56..94b4c6508044 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -3474,7 +3474,7 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
>>   	if (err == 0) {
>>   		if (result == 0 && (req->r_op == CEPH_MDS_OP_READDIR ||
>>   				    req->r_op == CEPH_MDS_OP_LSSNAP))
>> -			ceph_readdir_prepopulate(req, req->r_session);
>> +			err = ceph_readdir_prepopulate(req, req->r_session);
>>   	}
>>   	current->journal_info = NULL;
>>   	mutex_unlock(&req->r_fill_mutex);

