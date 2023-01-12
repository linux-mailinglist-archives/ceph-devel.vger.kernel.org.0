Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E06AA666AA5
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Jan 2023 06:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjALFGq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 12 Jan 2023 00:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236784AbjALFGn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 12 Jan 2023 00:06:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6AB6E06
        for <ceph-devel@vger.kernel.org>; Wed, 11 Jan 2023 21:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673499954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uGLbMrbJVQKlT8+rnJOYP46WDNWv5Q4Iw/k8Wmz3d88=;
        b=inEAPLfkVuoCiCS+qasmjLpUE3tHr6GsUM4E5WAZvV+/VrLNfMN5GCzvrAlA3Nd8lozYml
        QX7xmDc3haAsVmPsXZ6kPTFgo/oVQmLbE4Qle0JpwuYqoUHs+6uDpFVaNY9vM2lBzvrOBI
        OBcP/uH8JeFEUzitAe0E7Dgehy5KaHI=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-368-FutthWKJMImm2h2SxjD82Q-1; Thu, 12 Jan 2023 00:05:52 -0500
X-MC-Unique: FutthWKJMImm2h2SxjD82Q-1
Received: by mail-pl1-f197.google.com with SMTP id f8-20020a170902ce8800b00190c6518e21so11923098plg.1
        for <ceph-devel@vger.kernel.org>; Wed, 11 Jan 2023 21:05:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uGLbMrbJVQKlT8+rnJOYP46WDNWv5Q4Iw/k8Wmz3d88=;
        b=m2kxXvPWDRRD4xiRCaPLLMrb1tV7MNasl5H5z2gKgHscW4l1q2gIlEGuq6sp3ry966
         Lo6LAdrPqzjowkZpXpKLecGlc6iZxwb1YgvCFNE4SW6u017zPRSkbeXautJMrYT9PoCM
         QTVO74FvHhdB86VSs7Mj2Lg+k/sZI4SJ4/CRnIGTGREkmDmGIjpsqeQxaxKjvAOLqUvi
         UuNMn+UffQHnXL0Ce7P+KaNhl+ENzSqMHmV2mPwfTvoKFQj7iLVT2MPZW9j5owVKc4P7
         gH3ekkDdg5gUkOA9z7p7ojH+If+9aIDkAy/LrlHBe5ulz+mN7w3uIBDpJN6Hcn2XIoUU
         jH5w==
X-Gm-Message-State: AFqh2kq+USExLPmA+dK8xM00lV97LqfFUlKM4hPAPL0jsiywu7o2lB51
        VtDTUWLuxqa7GrW26AAqrIj9yL+NOTrAfEbm5+wLJyIn4A/exELRJXXBJWEFsRO9/iGL995N9bm
        57jLwgxuwWfbOW+GglnszwQ==
X-Received: by 2002:a62:f20f:0:b0:566:900d:5ae8 with SMTP id m15-20020a62f20f000000b00566900d5ae8mr64776310pfh.24.1673499951256;
        Wed, 11 Jan 2023 21:05:51 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvPAN2f3AwYhsLWNNeoNRWtREtFOjfY7xTiYYYU+D52Bfw/a2o5RNDXGQz8AUgvfxoXYu0VSQ==
X-Received: by 2002:a62:f20f:0:b0:566:900d:5ae8 with SMTP id m15-20020a62f20f000000b00566900d5ae8mr64776289pfh.24.1673499950842;
        Wed, 11 Jan 2023 21:05:50 -0800 (PST)
Received: from [10.72.12.200] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w1-20020a627b01000000b0058217bbc6f5sm10829653pfc.215.2023.01.11.21.05.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 21:05:50 -0800 (PST)
Message-ID: <9b20611c-c5e1-ae48-393c-93b1489dc3cf@redhat.com>
Date:   Thu, 12 Jan 2023 13:05:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [ceph-client:testing 17/77] fs/ceph/mds_client.c:218
 parse_reply_info_in() warn: missing unwind goto?
Content-Language: en-US
To:     Dan Carpenter <error27@gmail.com>, oe-kbuild@lists.linux.dev,
        Jeff Layton <jlayton@kernel.org>
Cc:     lkp@intel.com, oe-kbuild-all@lists.linux.dev,
        ceph-devel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>
References: <202301120708.Xouvfbeb-lkp@intel.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <202301120708.Xouvfbeb-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Thanks Dan,

On 12/01/2023 12:37, Dan Carpenter wrote:
> tree:   https://github.com/ceph/ceph-client.git testing
> head:   dd9ed6e7fed7f133e63ecadd3ea5b1140221df0b
> commit: d77b55b952a06f69cec796b9f675165d8aa6275d [17/77] ceph: fscrypt_auth handling for ceph
> config: parisc-randconfig-m031-20230110
> compiler: hppa-linux-gcc (GCC) 12.1.0
>
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <error27@gmail.com>
>
> New smatch warnings:
> fs/ceph/mds_client.c:218 parse_reply_info_in() warn: missing unwind goto?
>
> vim +218 fs/ceph/mds_client.c
>
> 2f2dc053404feb Sage Weil        2009-10-06  100  static int parse_reply_info_in(void **p, void *end,
> 14303d20f3ae3e Sage Weil        2010-12-14  101  			       struct ceph_mds_reply_info_in *info,
> 12b4629a9fb80f Ilya Dryomov     2013-12-24  102  			       u64 features)
> 2f2dc053404feb Sage Weil        2009-10-06  103  {
> b37fe1f923fb4b Yan, Zheng       2019-01-09  104  	int err = 0;
> b37fe1f923fb4b Yan, Zheng       2019-01-09  105  	u8 struct_v = 0;
> b37fe1f923fb4b Yan, Zheng       2019-01-09  106
> b37fe1f923fb4b Yan, Zheng       2019-01-09  107  	if (features == (u64)-1) {
> b37fe1f923fb4b Yan, Zheng       2019-01-09  108  		u32 struct_len;
> b37fe1f923fb4b Yan, Zheng       2019-01-09  109  		u8 struct_compat;
> b37fe1f923fb4b Yan, Zheng       2019-01-09  110  		ceph_decode_8_safe(p, end, struct_v, bad);
> b37fe1f923fb4b Yan, Zheng       2019-01-09  111  		ceph_decode_8_safe(p, end, struct_compat, bad);
> b37fe1f923fb4b Yan, Zheng       2019-01-09  112  		/* struct_v is expected to be >= 1. we only understand
> b37fe1f923fb4b Yan, Zheng       2019-01-09  113  		 * encoding with struct_compat == 1. */
> b37fe1f923fb4b Yan, Zheng       2019-01-09  114  		if (!struct_v || struct_compat != 1)
> b37fe1f923fb4b Yan, Zheng       2019-01-09  115  			goto bad;
> b37fe1f923fb4b Yan, Zheng       2019-01-09  116  		ceph_decode_32_safe(p, end, struct_len, bad);
> b37fe1f923fb4b Yan, Zheng       2019-01-09  117  		ceph_decode_need(p, end, struct_len, bad);
> b37fe1f923fb4b Yan, Zheng       2019-01-09  118  		end = *p + struct_len;
> b37fe1f923fb4b Yan, Zheng       2019-01-09  119  	}
> 2f2dc053404feb Sage Weil        2009-10-06  120
> b37fe1f923fb4b Yan, Zheng       2019-01-09  121  	ceph_decode_need(p, end, sizeof(struct ceph_mds_reply_inode), bad);
> 2f2dc053404feb Sage Weil        2009-10-06  122  	info->in = *p;
> 2f2dc053404feb Sage Weil        2009-10-06  123  	*p += sizeof(struct ceph_mds_reply_inode) +
> 2f2dc053404feb Sage Weil        2009-10-06  124  		sizeof(*info->in->fragtree.splits) *
> 2f2dc053404feb Sage Weil        2009-10-06  125  		le32_to_cpu(info->in->fragtree.nsplits);
> 2f2dc053404feb Sage Weil        2009-10-06  126
> 2f2dc053404feb Sage Weil        2009-10-06  127  	ceph_decode_32_safe(p, end, info->symlink_len, bad);
> 2f2dc053404feb Sage Weil        2009-10-06  128  	ceph_decode_need(p, end, info->symlink_len, bad);
> 2f2dc053404feb Sage Weil        2009-10-06  129  	info->symlink = *p;
> 2f2dc053404feb Sage Weil        2009-10-06  130  	*p += info->symlink_len;
> 2f2dc053404feb Sage Weil        2009-10-06  131
> 14303d20f3ae3e Sage Weil        2010-12-14  132  	ceph_decode_copy_safe(p, end, &info->dir_layout,
> 14303d20f3ae3e Sage Weil        2010-12-14  133  			      sizeof(info->dir_layout), bad);
> 2f2dc053404feb Sage Weil        2009-10-06  134  	ceph_decode_32_safe(p, end, info->xattr_len, bad);
> 2f2dc053404feb Sage Weil        2009-10-06  135  	ceph_decode_need(p, end, info->xattr_len, bad);
> 2f2dc053404feb Sage Weil        2009-10-06  136  	info->xattr_data = *p;
> 2f2dc053404feb Sage Weil        2009-10-06  137  	*p += info->xattr_len;
> fb01d1f8b0343f Yan, Zheng       2014-11-14  138
> b37fe1f923fb4b Yan, Zheng       2019-01-09  139  	if (features == (u64)-1) {
> b37fe1f923fb4b Yan, Zheng       2019-01-09  140  		/* inline data */
> b37fe1f923fb4b Yan, Zheng       2019-01-09  141  		ceph_decode_64_safe(p, end, info->inline_version, bad);
> b37fe1f923fb4b Yan, Zheng       2019-01-09  142  		ceph_decode_32_safe(p, end, info->inline_len, bad);
> b37fe1f923fb4b Yan, Zheng       2019-01-09  143  		ceph_decode_need(p, end, info->inline_len, bad);
> b37fe1f923fb4b Yan, Zheng       2019-01-09  144  		info->inline_data = *p;
> b37fe1f923fb4b Yan, Zheng       2019-01-09  145  		*p += info->inline_len;
> b37fe1f923fb4b Yan, Zheng       2019-01-09  146  		/* quota */
> b37fe1f923fb4b Yan, Zheng       2019-01-09  147  		err = parse_reply_info_quota(p, end, info);
> b37fe1f923fb4b Yan, Zheng       2019-01-09  148  		if (err < 0)
> b37fe1f923fb4b Yan, Zheng       2019-01-09  149  			goto out_bad;
>                                                                          ^^^^^^^^^^^^
>
>
> b37fe1f923fb4b Yan, Zheng       2019-01-09  150  		/* pool namespace */
> b37fe1f923fb4b Yan, Zheng       2019-01-09  151  		ceph_decode_32_safe(p, end, info->pool_ns_len, bad);
> b37fe1f923fb4b Yan, Zheng       2019-01-09  152  		if (info->pool_ns_len > 0) {
> b37fe1f923fb4b Yan, Zheng       2019-01-09  153  			ceph_decode_need(p, end, info->pool_ns_len, bad);
> b37fe1f923fb4b Yan, Zheng       2019-01-09  154  			info->pool_ns_data = *p;
> b37fe1f923fb4b Yan, Zheng       2019-01-09  155  			*p += info->pool_ns_len;
> b37fe1f923fb4b Yan, Zheng       2019-01-09  156  		}
> 245ce991cca55e Jeff Layton      2019-05-29  157
> 245ce991cca55e Jeff Layton      2019-05-29  158  		/* btime */
> 245ce991cca55e Jeff Layton      2019-05-29  159  		ceph_decode_need(p, end, sizeof(info->btime), bad);
> 245ce991cca55e Jeff Layton      2019-05-29  160  		ceph_decode_copy(p, &info->btime, sizeof(info->btime));
> 245ce991cca55e Jeff Layton      2019-05-29  161
> 245ce991cca55e Jeff Layton      2019-05-29  162  		/* change attribute */
> a35ead314e0b92 Jeff Layton      2019-06-06  163  		ceph_decode_64_safe(p, end, info->change_attr, bad);
> b37fe1f923fb4b Yan, Zheng       2019-01-09  164
> 08796873a5183b Yan, Zheng       2019-01-09  165  		/* dir pin */
> 08796873a5183b Yan, Zheng       2019-01-09  166  		if (struct_v >= 2) {
> 08796873a5183b Yan, Zheng       2019-01-09  167  			ceph_decode_32_safe(p, end, info->dir_pin, bad);
> 08796873a5183b Yan, Zheng       2019-01-09  168  		} else {
> 08796873a5183b Yan, Zheng       2019-01-09  169  			info->dir_pin = -ENODATA;
> 08796873a5183b Yan, Zheng       2019-01-09  170  		}
> 08796873a5183b Yan, Zheng       2019-01-09  171
> 193e7b37628e97 David Disseldorp 2019-04-18  172  		/* snapshot birth time, remains zero for v<=2 */
> 193e7b37628e97 David Disseldorp 2019-04-18  173  		if (struct_v >= 3) {
> 193e7b37628e97 David Disseldorp 2019-04-18  174  			ceph_decode_need(p, end, sizeof(info->snap_btime), bad);
> 193e7b37628e97 David Disseldorp 2019-04-18  175  			ceph_decode_copy(p, &info->snap_btime,
> 193e7b37628e97 David Disseldorp 2019-04-18  176  					 sizeof(info->snap_btime));
> 193e7b37628e97 David Disseldorp 2019-04-18  177  		} else {
> 193e7b37628e97 David Disseldorp 2019-04-18  178  			memset(&info->snap_btime, 0, sizeof(info->snap_btime));
> 193e7b37628e97 David Disseldorp 2019-04-18  179  		}
> 193e7b37628e97 David Disseldorp 2019-04-18  180
> e7f72952508ac4 Yanhu Cao        2020-08-28  181  		/* snapshot count, remains zero for v<=3 */
> e7f72952508ac4 Yanhu Cao        2020-08-28  182  		if (struct_v >= 4) {
> e7f72952508ac4 Yanhu Cao        2020-08-28  183  			ceph_decode_64_safe(p, end, info->rsnaps, bad);
> e7f72952508ac4 Yanhu Cao        2020-08-28  184  		} else {
> e7f72952508ac4 Yanhu Cao        2020-08-28  185  			info->rsnaps = 0;
> e7f72952508ac4 Yanhu Cao        2020-08-28  186  		}
> e7f72952508ac4 Yanhu Cao        2020-08-28  187
> d77b55b952a06f Jeff Layton      2020-07-27  188  		if (struct_v >= 5) {
> d77b55b952a06f Jeff Layton      2020-07-27  189  			u32 alen;
> d77b55b952a06f Jeff Layton      2020-07-27  190
> d77b55b952a06f Jeff Layton      2020-07-27  191  			ceph_decode_32_safe(p, end, alen, bad);
> d77b55b952a06f Jeff Layton      2020-07-27  192
> d77b55b952a06f Jeff Layton      2020-07-27  193  			while (alen--) {
> d77b55b952a06f Jeff Layton      2020-07-27  194  				u32 len;
> d77b55b952a06f Jeff Layton      2020-07-27  195
> d77b55b952a06f Jeff Layton      2020-07-27  196  				/* key */
> d77b55b952a06f Jeff Layton      2020-07-27  197  				ceph_decode_32_safe(p, end, len, bad);
> d77b55b952a06f Jeff Layton      2020-07-27  198  				ceph_decode_skip_n(p, end, len, bad);
> d77b55b952a06f Jeff Layton      2020-07-27  199  				/* value */
> d77b55b952a06f Jeff Layton      2020-07-27  200  				ceph_decode_32_safe(p, end, len, bad);
> d77b55b952a06f Jeff Layton      2020-07-27  201  				ceph_decode_skip_n(p, end, len, bad);
> d77b55b952a06f Jeff Layton      2020-07-27  202  			}
> d77b55b952a06f Jeff Layton      2020-07-27  203  		}
> d77b55b952a06f Jeff Layton      2020-07-27  204
> d77b55b952a06f Jeff Layton      2020-07-27  205  		/* fscrypt flag -- ignore */
> d77b55b952a06f Jeff Layton      2020-07-27  206  		if (struct_v >= 6)
> d77b55b952a06f Jeff Layton      2020-07-27  207  			ceph_decode_skip_8(p, end, bad);
> d77b55b952a06f Jeff Layton      2020-07-27  208
> d77b55b952a06f Jeff Layton      2020-07-27  209  		info->fscrypt_auth = NULL;
> d77b55b952a06f Jeff Layton      2020-07-27  210  		info->fscrypt_auth_len = 0;
> d77b55b952a06f Jeff Layton      2020-07-27  211  		info->fscrypt_file = NULL;
> d77b55b952a06f Jeff Layton      2020-07-27  212  		info->fscrypt_file_len = 0;
> d77b55b952a06f Jeff Layton      2020-07-27  213  		if (struct_v >= 7) {
> d77b55b952a06f Jeff Layton      2020-07-27  214  			ceph_decode_32_safe(p, end, info->fscrypt_auth_len, bad);
> d77b55b952a06f Jeff Layton      2020-07-27  215  			if (info->fscrypt_auth_len) {
> d77b55b952a06f Jeff Layton      2020-07-27  216  				info->fscrypt_auth = kmalloc(info->fscrypt_auth_len, GFP_KERNEL);
> d77b55b952a06f Jeff Layton      2020-07-27  217  				if (!info->fscrypt_auth)
> d77b55b952a06f Jeff Layton      2020-07-27 @218  					return -ENOMEM;
>
> When I scroll down, it turns out that the error labels in this function
> are just Pointless Do Nothing Gotos.  Smatch tries to ignore this, but
> the bad: label sets the error code so Smatch marks it as a Do Something
> label.
>
> Ideally everything would be converted to direct returns...

The following patch should fix it:

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 43a9a17ed9eb..726519b637db 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -215,16 +215,20 @@ static int parse_reply_info_in(void **p, void *end,
                         ceph_decode_32_safe(p, end, 
info->fscrypt_auth_len, bad);
                         if (info->fscrypt_auth_len) {
                                 info->fscrypt_auth = 
kmalloc(info->fscrypt_auth_len, GFP_KERNEL);
-                               if (!info->fscrypt_auth)
-                                       return -ENOMEM;
+                               if (!info->fscrypt_auth) {
+                                       err = -ENOMEM;
+                                       goto out_bad;
+                               }
                                 ceph_decode_copy_safe(p, end, 
info->fscrypt_auth,
info->fscrypt_auth_len, bad);
                         }
                         ceph_decode_32_safe(p, end, 
info->fscrypt_file_len, bad);
                         if (info->fscrypt_file_len) {
                                 info->fscrypt_file = 
kmalloc(info->fscrypt_file_len, GFP_KERNEL);
-                               if (!info->fscrypt_file)
-                                       return -ENOMEM;
+                               if (!info->fscrypt_file) {
+                                       err = -ENOMEM;
+                                       goto out_bad;
+                               }
                                 ceph_decode_copy_safe(p, end, 
info->fscrypt_file,
info->fscrypt_file_len, bad);
                         }

Thanks

- Xiubo


>
> d77b55b952a06f Jeff Layton      2020-07-27  219  				ceph_decode_copy_safe(p, end, info->fscrypt_auth,
> d77b55b952a06f Jeff Layton      2020-07-27  220  						      info->fscrypt_auth_len, bad);
> d77b55b952a06f Jeff Layton      2020-07-27  221  			}
> d77b55b952a06f Jeff Layton      2020-07-27  222  			ceph_decode_32_safe(p, end, info->fscrypt_file_len, bad);
> d77b55b952a06f Jeff Layton      2020-07-27  223  			if (info->fscrypt_file_len) {
> d77b55b952a06f Jeff Layton      2020-07-27  224  				info->fscrypt_file = kmalloc(info->fscrypt_file_len, GFP_KERNEL);
> d77b55b952a06f Jeff Layton      2020-07-27  225  				if (!info->fscrypt_file)
> d77b55b952a06f Jeff Layton      2020-07-27  226  					return -ENOMEM;
> d77b55b952a06f Jeff Layton      2020-07-27  227  				ceph_decode_copy_safe(p, end, info->fscrypt_file,
> d77b55b952a06f Jeff Layton      2020-07-27  228  						      info->fscrypt_file_len, bad);
> d77b55b952a06f Jeff Layton      2020-07-27  229  			}
> d77b55b952a06f Jeff Layton      2020-07-27  230  		}
> b37fe1f923fb4b Yan, Zheng       2019-01-09  231  		*p = end;
> b37fe1f923fb4b Yan, Zheng       2019-01-09  232  	} else {
> d77b55b952a06f Jeff Layton      2020-07-27  233  		/* legacy (unversioned) struct */
> fb01d1f8b0343f Yan, Zheng       2014-11-14  234  		if (features & CEPH_FEATURE_MDS_INLINE_DATA) {
> fb01d1f8b0343f Yan, Zheng       2014-11-14  235  			ceph_decode_64_safe(p, end, info->inline_version, bad);
> fb01d1f8b0343f Yan, Zheng       2014-11-14  236  			ceph_decode_32_safe(p, end, info->inline_len, bad);
> fb01d1f8b0343f Yan, Zheng       2014-11-14  237  			ceph_decode_need(p, end, info->inline_len, bad);
> fb01d1f8b0343f Yan, Zheng       2014-11-14  238  			info->inline_data = *p;
> fb01d1f8b0343f Yan, Zheng       2014-11-14  239  			*p += info->inline_len;
> fb01d1f8b0343f Yan, Zheng       2014-11-14  240  		} else
> fb01d1f8b0343f Yan, Zheng       2014-11-14  241  			info->inline_version = CEPH_INLINE_NONE;
> fb01d1f8b0343f Yan, Zheng       2014-11-14  242
> fb18a57568c2b8 Luis Henriques   2018-01-05  243  		if (features & CEPH_FEATURE_MDS_QUOTA) {
> b37fe1f923fb4b Yan, Zheng       2019-01-09  244  			err = parse_reply_info_quota(p, end, info);
> b37fe1f923fb4b Yan, Zheng       2019-01-09  245  			if (err < 0)
> b37fe1f923fb4b Yan, Zheng       2019-01-09  246  				goto out_bad;
> fb18a57568c2b8 Luis Henriques   2018-01-05  247  		} else {
> fb18a57568c2b8 Luis Henriques   2018-01-05  248  			info->max_bytes = 0;
> fb18a57568c2b8 Luis Henriques   2018-01-05  249  			info->max_files = 0;
> fb18a57568c2b8 Luis Henriques   2018-01-05  250  		}
> fb18a57568c2b8 Luis Henriques   2018-01-05  251
> 779fe0fb8e1883 Yan, Zheng       2016-03-07  252  		info->pool_ns_len = 0;
> 779fe0fb8e1883 Yan, Zheng       2016-03-07  253  		info->pool_ns_data = NULL;
> 5ea5c5e0a7f70b Yan, Zheng       2016-02-14  254  		if (features & CEPH_FEATURE_FS_FILE_LAYOUT_V2) {
> 5ea5c5e0a7f70b Yan, Zheng       2016-02-14  255  			ceph_decode_32_safe(p, end, info->pool_ns_len, bad);
> 779fe0fb8e1883 Yan, Zheng       2016-03-07  256  			if (info->pool_ns_len > 0) {
> 5ea5c5e0a7f70b Yan, Zheng       2016-02-14  257  				ceph_decode_need(p, end, info->pool_ns_len, bad);
> 779fe0fb8e1883 Yan, Zheng       2016-03-07  258  				info->pool_ns_data = *p;
> 5ea5c5e0a7f70b Yan, Zheng       2016-02-14  259  				*p += info->pool_ns_len;
> 779fe0fb8e1883 Yan, Zheng       2016-03-07  260  			}
> 5ea5c5e0a7f70b Yan, Zheng       2016-02-14  261  		}
> 08796873a5183b Yan, Zheng       2019-01-09  262
> 245ce991cca55e Jeff Layton      2019-05-29  263  		if (features & CEPH_FEATURE_FS_BTIME) {
> 245ce991cca55e Jeff Layton      2019-05-29  264  			ceph_decode_need(p, end, sizeof(info->btime), bad);
> 245ce991cca55e Jeff Layton      2019-05-29  265  			ceph_decode_copy(p, &info->btime, sizeof(info->btime));
> a35ead314e0b92 Jeff Layton      2019-06-06  266  			ceph_decode_64_safe(p, end, info->change_attr, bad);
> 245ce991cca55e Jeff Layton      2019-05-29  267  		}
> 245ce991cca55e Jeff Layton      2019-05-29  268
> 08796873a5183b Yan, Zheng       2019-01-09  269  		info->dir_pin = -ENODATA;
> e7f72952508ac4 Yanhu Cao        2020-08-28  270  		/* info->snap_btime and info->rsnaps remain zero */
> b37fe1f923fb4b Yan, Zheng       2019-01-09  271  	}
> 2f2dc053404feb Sage Weil        2009-10-06  272  	return 0;
> 2f2dc053404feb Sage Weil        2009-10-06  273  bad:
> b37fe1f923fb4b Yan, Zheng       2019-01-09  274  	err = -EIO;
> b37fe1f923fb4b Yan, Zheng       2019-01-09  275  out_bad:
> 2f2dc053404feb Sage Weil        2009-10-06  276  	return err;
> 2f2dc053404feb Sage Weil        2009-10-06  277  }
>
-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li

