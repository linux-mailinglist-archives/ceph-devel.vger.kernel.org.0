Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7F04D9B7D
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Mar 2022 13:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348434AbiCOMr5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Mar 2022 08:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233130AbiCOMr4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Mar 2022 08:47:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D70D45784
        for <ceph-devel@vger.kernel.org>; Tue, 15 Mar 2022 05:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647348403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KrZuUFT6eG57BUlFINyHVaeSbSUMnth1bwaS2/woWLo=;
        b=GlyIjIQ5hfNsiRYOJ99qdMCq+vudmf3sV4jUd2GyRQGzVkCnoIoJ3nNmYwq6R3zlg90yVE
        1ShQC0YVFK/AfxB4IVabXUG7WvSdh/UtZa76Jk7TDy/EW2GQbOF5JpkqZoho/fJFKaoRiS
        50E5EJB2rf801sG7bLvyzeA0QN0zK+s=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-75-0R2R4gI2Mk-nbt9LPcKnJA-1; Tue, 15 Mar 2022 08:46:41 -0400
X-MC-Unique: 0R2R4gI2Mk-nbt9LPcKnJA-1
Received: by mail-pf1-f198.google.com with SMTP id x123-20020a626381000000b004f6fc50208eso11823557pfb.11
        for <ceph-devel@vger.kernel.org>; Tue, 15 Mar 2022 05:46:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=KrZuUFT6eG57BUlFINyHVaeSbSUMnth1bwaS2/woWLo=;
        b=0e8GF9KFi7PmylEEd9c7NLd5+flYKMyRkwmeis0xEO5DlF8EShggMMb3KftHU4f1Gh
         wr4svac/h6ZKCTQu39Cxs5ropt6AbFv05ECrjb6AxQY+BCnmCeW3BmVfpyF8Xeh4msOn
         Y10Skz6cgC9iyFrtx9xOu1kQUHsQDv+xcU+OmHNdJqQXuvC4Zwc/SvuQHH1MWUcK24ms
         HBe5hv7wy0pFLHJVwx/jCOuKQ9AAsUIGMZHBP/QPDgiU3lS1InmXXNXzya1yceyVx89b
         0PeZ1c3hky7IJw5VY37XHFVEOHk8evihgxY1gNnqUeZ7cPQJ/q3bwkh7UDy54WlG7sxp
         kCFQ==
X-Gm-Message-State: AOAM532guXUmhcHn16UT2dO3iWu+ZYPEl5PkjH/3e/tEavF8CF91tLAJ
        DACqormK/0dhTQDI4FVucHOCN15VqFCAUuNiNVqT2p8EPyabhc8tsnu7TuLEcxM6YHEwIC3D0oK
        sGVl4hyC1ZePOT0JGhbj22JMZRktNuhjqRUH/wh8C3rV/g+z7piRbPJQ1Of34j31iRa9SlaU=
X-Received: by 2002:a17:90a:ad88:b0:1be:ec99:a695 with SMTP id s8-20020a17090aad8800b001beec99a695mr4420400pjq.119.1647348400153;
        Tue, 15 Mar 2022 05:46:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9CSWzOxogWJy3Hq9+04bXYDiWwvS+zXl4Cl2XUI7SNfABcvgzcCZjfnk9DzQvt6ByLd2DhQ==
X-Received: by 2002:a17:90a:ad88:b0:1be:ec99:a695 with SMTP id s8-20020a17090aad8800b001beec99a695mr4420358pjq.119.1647348399801;
        Tue, 15 Mar 2022 05:46:39 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u25-20020a62ed19000000b004f140515d56sm23704640pfh.46.2022.03.15.05.46.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 05:46:39 -0700 (PDT)
Subject: Re: [PATCH v2] ceph: send the fscrypt_auth to MDS via request
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
References: <20220315093741.25664-1-xiubli@redhat.com>
 <db065a435d712ca9ec9245bdad3f43dc8e271385.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <e2444dc2-0066-4cb3-a70a-b8272c8e9681@redhat.com>
Date:   Tue, 15 Mar 2022 20:46:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <db065a435d712ca9ec9245bdad3f43dc8e271385.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/15/22 8:41 PM, Jeff Layton wrote:
> On Tue, 2022-03-15 at 17:37 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Currently when creating new files or directories the kclient will
>> create a new inode and fill the fscrypt auth locally, without sending
>> it to MDS via requests. Then the MDS reply with it to empty too.
>> And the kclient will update it later together with the cap update
>> requests.
>>
>> It's buggy if just after the create requests succeeds but the kclient
>> crash and reboot, then in MDS side the fscrypt_auth will keep empty.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> V2:
>> - Fix the compile errors without CONFIG_FS_ENCRYPTION enabled.
>>
>>
>>
>>   fs/ceph/dir.c  | 43 +++++++++++++++++++++++++++++++++++++++++--
>>   fs/ceph/file.c | 17 ++++++++++++++++-
>>   2 files changed, 57 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>> index 5ae5cb778389..8675898a4336 100644
>> --- a/fs/ceph/dir.c
>> +++ b/fs/ceph/dir.c
>> @@ -904,8 +904,22 @@ static int ceph_mknod(struct user_namespace *mnt_userns, struct inode *dir,
>>   		goto out_req;
>>   	}
>>   
>> -	if (S_ISREG(mode) && IS_ENCRYPTED(dir))
>> -		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
>> +	if (IS_ENCRYPTED(dir)) {
>> +#ifdef CONFIG_FS_ENCRYPTION
>> +		struct ceph_inode_info *ci = ceph_inode(req->r_new_inode);
>> +
>> +		req->r_fscrypt_auth = kmemdup(ci->fscrypt_auth,
>> +					      ci->fscrypt_auth_len,
>> +					      GFP_KERNEL);
>> +		if (!req->r_fscrypt_auth) {
>> +			err = -ENOMEM;
>> +			goto out_req;
>> +		}
>> +#endif
> I thought ceph_as_ctx_to_req was supposed to populate this field. If
> that's not happening here then there is a bug in that codepath, and we
> should just fix that instead of doing a workaround like this.

I may miss this and will check it.

- Xiubo


>> +
>> +		if (S_ISREG(mode))
>> +			set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
>> +	}
>>   
>>   	req->r_dentry = dget(dentry);
>>   	req->r_num_caps = 2;
>> @@ -1008,6 +1022,18 @@ static int ceph_symlink(struct user_namespace *mnt_userns, struct inode *dir,
>>   	ihold(dir);
>>   
>>   	if (IS_ENCRYPTED(req->r_new_inode)) {
>> +#ifdef CONFIG_FS_ENCRYPTION
>> +		struct ceph_inode_info *ci = ceph_inode(req->r_new_inode);
>> +
>> +		req->r_fscrypt_auth = kmemdup(ci->fscrypt_auth,
>> +					      ci->fscrypt_auth_len,
>> +					      GFP_KERNEL);
>> +		if (!req->r_fscrypt_auth) {
>> +			err = -ENOMEM;
>> +			goto out_req;
>> +		}
>> +#endif
>> +
>>   		err = prep_encrypted_symlink_target(req, dest);
>>   		if (err)
>>   			goto out_req;
>> @@ -1081,6 +1107,19 @@ static int ceph_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
>>   		goto out_req;
>>   	}
>>   
>> +#ifdef CONFIG_FS_ENCRYPTION
>> +	if (IS_ENCRYPTED(dir)) {
>> +		struct ceph_inode_info *ci = ceph_inode(req->r_new_inode);
>> +
>> +		req->r_fscrypt_auth = kmemdup(ci->fscrypt_auth,
>> +					      ci->fscrypt_auth_len,
>> +					      GFP_KERNEL);
>> +		if (!req->r_fscrypt_auth) {
>> +			err = -ENOMEM;
>> +			goto out_req;
>> +		}
>> +	}
>> +#endif
>>   	req->r_dentry = dget(dentry);
>>   	req->r_num_caps = 2;
>>   	req->r_parent = dir;
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 61ffbda5b934..70ac41d6e0d4 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -771,9 +771,24 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>>   	req->r_args.open.mask = cpu_to_le32(mask);
>>   	req->r_parent = dir;
>>   	ihold(dir);
>> -	if (IS_ENCRYPTED(dir))
>> +	if (IS_ENCRYPTED(dir)) {
>>   		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
>>   
>> +#ifdef CONFIG_FS_ENCRYPTION
>> +		if (new_inode) {
>> +			struct ceph_inode_info *ci = ceph_inode(new_inode);
>> +
>> +			req->r_fscrypt_auth = kmemdup(ci->fscrypt_auth,
>> +						      ci->fscrypt_auth_len,
>> +						      GFP_KERNEL);
>> +			if (!req->r_fscrypt_auth) {
>> +				err = -ENOMEM;
>> +				goto out_req;
>> +			}
>> +		}
>> +#endif
>> +	}
>> +
>>   	if (flags & O_CREAT) {
>>   		struct ceph_file_layout lo;
>>   

