Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7786FD355
	for <lists+ceph-devel@lfdr.de>; Wed, 10 May 2023 02:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbjEJAnI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 May 2023 20:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjEJAnG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 9 May 2023 20:43:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15ED3173B
        for <ceph-devel@vger.kernel.org>; Tue,  9 May 2023 17:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683679339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vYMxzuXNBR9QunAaAh5Y4n8FuwvSDfegGoNr0yZxTFg=;
        b=eH7z+SDjewJzmdQ5TEN1QRc/bHBDMuaRz3wqMYvROY+IroSHym+QRA/TJLQME4/DRLmWtw
        8olT3ePqvRpvSqrrPxCZWSbzOQgqsz1IMK0X6UABzIy0oxuZfnJzgm0PJE65PhFfaJIdVN
        l7U91lDaQbE+gH7CFfHdKVFT00XHddo=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-552-eW5TkS19OMu2K86HzpIp-g-1; Tue, 09 May 2023 20:42:17 -0400
X-MC-Unique: eW5TkS19OMu2K86HzpIp-g-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-518d6f87a47so3110356a12.3
        for <ceph-devel@vger.kernel.org>; Tue, 09 May 2023 17:42:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683679337; x=1686271337;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vYMxzuXNBR9QunAaAh5Y4n8FuwvSDfegGoNr0yZxTFg=;
        b=est/0cZ96WBRMaxOQ97BekyznXcjKhmEDkCnWh52OOVbxgSQco3oA9VVNlcY+pCUR4
         5e+c334frMi5JA960zo0Wgxk0xMlF54yCaaCLRW46VkHyn3JtZyBD3sbXU/0vtV9XFYH
         8jla8WtHraonNs/xO+ah6iJPhyIQZWIYt7bMSso2uUfD5bQiPrUUA1jYSYa07A2zTqPQ
         5Lm496NxCWYueADA3uttB/aiSXtGe0TxOuQXcqLSor4Ol4Lh45w3SkXm/qGbYPFooFBO
         9Wa8k2S9sgQgRKTNefZbCQaDQ5EYvRarStpcCzTaEKgJsFBtdj6bgkvISjL8hYHrtSLj
         4efQ==
X-Gm-Message-State: AC+VfDxuuFPOimMMAZnKZlz3CxCHxK2O0ZecGXNmFWHtEeMl+ZHShX6f
        1YR8JUZXu0GzrnhKDmrHXdY7viPRzGj948OR6Yn728KoiXXfIcFdawfwbMKkfsaLitVO6poHjR7
        IDR2g3KW6nWSJhSBv9V8jFw==
X-Received: by 2002:a05:6a20:8f13:b0:101:3fe5:8776 with SMTP id b19-20020a056a208f1300b001013fe58776mr5256045pzk.17.1683679336775;
        Tue, 09 May 2023 17:42:16 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ65etYwQJ1mivLGcLSR/5R00sYmNEpliZI4r/6Ebehs1/GVcW52fMVsDdiUXi3z1b4NpMg94w==
X-Received: by 2002:a05:6a20:8f13:b0:101:3fe5:8776 with SMTP id b19-20020a056a208f1300b001013fe58776mr5256023pzk.17.1683679336492;
        Tue, 09 May 2023 17:42:16 -0700 (PDT)
Received: from [10.72.12.156] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id t23-20020a62ea17000000b0062cf75a9e6bsm2345911pfh.131.2023.05.09.17.42.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 May 2023 17:42:16 -0700 (PDT)
Message-ID: <fda4ef57-0b5b-3a24-bacc-1d5b0cc302bb@redhat.com>
Date:   Wed, 10 May 2023 08:42:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 2/3] ceph: save name and fsid in mount source
Content-Language: en-US
To:     =?UTF-8?B?6IOh546u5paH?= <huww98@outlook.com>
Cc:     ceph-devel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        Hu Weiwen <sehuww@mail.scut.edu.cn>
References: <TYCP286MB20661F87B0C796738BDC5FBEC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
 <TYCP286MB206604655F7CAB7C50C6218FC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
 <1c6da9b7-f424-1713-23a6-15999d954f28@redhat.com>
 <TYCP286MB20667D17632479D0BFCD48B5C0769@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <TYCP286MB20667D17632479D0BFCD48B5C0769@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/9/23 21:55, 胡玮文 wrote:
> On Tue, May 09, 2023 at 09:36:16AM +0800, Xiubo Li wrote:
>> On 5/8/23 01:55, Hu Weiwen wrote:
>>> From: Hu Weiwen <sehuww@mail.scut.edu.cn>
>>>
>>> We have name and fsid in the new device syntax.  It is confusing that
>>> the kernel accept these info but do not take them into account when
>>> connecting to the cluster.
>>>
>>> Although the mount.ceph helper program will extract the name from device
>>> spec and pass it as name options, these changes are still useful if we
>>> don't have that program installed, or if we want to call `mount()'
>>> directly.
>>>
>>> Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
>>> ---
>>>    fs/ceph/super.c | 17 +++++++++++++++++
>>>    1 file changed, 17 insertions(+)
>>>
>>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>>> index 4e1f4031e888..74636b9383b8 100644
>>> --- a/fs/ceph/super.c
>>> +++ b/fs/ceph/super.c
>>> @@ -267,6 +267,7 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
>>>    	struct ceph_fsid fsid;
>>>    	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
>>>    	struct ceph_mount_options *fsopt = pctx->opts;
>>> +	struct ceph_options *copts = pctx->copts;
>>>    	char *fsid_start, *fs_name_start;
>>>    	if (*dev_name_end != '=') {
>>> @@ -285,6 +286,12 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
>>>    	if (ceph_parse_fsid(fsid_start, &fsid))
>>>    		return invalfc(fc, "Invalid FSID");
>>> +	if (!(copts->flags & CEPH_OPT_FSID)) {
>>> +		copts->fsid = fsid;
>>> +		copts->flags |= CEPH_OPT_FSID;
>>> +	} else if (ceph_fsid_compare(&fsid, &copts->fsid)) {
>>> +		return invalfc(fc, "Mismatching cluster FSID");
>>> +	}
>>>    	++fs_name_start; /* start of file system name */
>>>    	len = dev_name_end - fs_name_start;
>>> @@ -298,6 +305,16 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
>>>    	}
>>>    	dout("file system (mds namespace) '%s'\n", fsopt->mds_namespace);
>>> +	len = fsid_start - dev_name - 1;
>>> +	if (!copts->name) {
>>> +		copts->name = kstrndup(dev_name, len, GFP_KERNEL);
>>> +		if (!copts->name)
>>> +			return -ENOMEM;
>> Shouldn't we kfree the 'copts->mds_namespace' here ?
> Seems not necessary.  ceph_free_fc() will take care of releasing the
> whole 'struct ceph_parse_opts_ctx', including 'copts->mds_namespace'.
> Besides, the mds_namespace may already be set before we parse the source
> here.
>
> ceph_free_fc() is called from:
> put_fs_context

457 void put_fs_context(struct fs_context *fc)
458 {
459         struct super_block *sb;
460
461         if (fc->root) {
462                 sb = fc->root->d_sb;
463                 dput(fc->root);
464                 fc->root = NULL;
465                 deactivate_super(sb);
466         }
467
468         if (fc->need_free && fc->ops && fc->ops->free)
469                 fc->ops->free(fc);

But are u sure the 'fc->need_free' is correctly set ?

It seems not from my reading if I didn't miss something.

Thanks

- Xiubo

> do_new_mount
> do_mount
>
>>> +	} else if (!strstrn_equals(copts->name, dev_name, len)) {
>>> +		return invalfc(fc, "Mismatching cephx name");
>>> +	}
>>> +	dout("cephx name '%s'\n", copts->name);
>>> +
>>>    	fsopt->new_dev_syntax = true;
>>>    	return 0;
>>>    }

