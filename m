Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDCA0573919
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Jul 2022 16:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236398AbiGMOnl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 13 Jul 2022 10:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236609AbiGMOnj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 13 Jul 2022 10:43:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 48FD01B5
        for <ceph-devel@vger.kernel.org>; Wed, 13 Jul 2022 07:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657723411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hNgAaLi4Gch6z3OyO3wEIKiEgkzd5xmCKhssX9Q1P+I=;
        b=d1Kl/LUcqJMDdVe8wrMmEzqWgqpSQqLP+EIbFDndk5NPUUptVBSitfisJMwyO0N+MLWUt3
        isoB08RGjiScCg2Q17XtHTDpmbRPvyAMjgGU6J3g3XFIrbOJulhFD8KMRDiVe/TUCLODHo
        RLEOfGBbUBqgmfwrVp7W5xKWT+IsN4E=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-211-lty62NeZPSyD3Ng5ixnq9g-1; Wed, 13 Jul 2022 10:43:30 -0400
X-MC-Unique: lty62NeZPSyD3Ng5ixnq9g-1
Received: by mail-pg1-f200.google.com with SMTP id u24-20020a63d358000000b004119798494fso5319174pgi.18
        for <ceph-devel@vger.kernel.org>; Wed, 13 Jul 2022 07:43:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=hNgAaLi4Gch6z3OyO3wEIKiEgkzd5xmCKhssX9Q1P+I=;
        b=TngTupszKg7TatqhN8//5tnNLfTEQenOPJHIcQPwtG6vH11lI+72THphPHXSs1b48w
         iHW6zj0M7YsTfURofEjcHyauHgDPPfhoOS+a+AdtS1MV0LzUnbKlg1v2+w3lahB/OBhm
         sQY+AicN+sLDmggrhvUvmf0IZiQ8Ho8afMkJGDNjQrFi8rSWlR+UnZ/OM8hgOB9SbCEB
         XyE6ATrFWzs7G4umLF/OQBxstaom0mggcC2nDDxKDlIUBYRU60ZJMnDVSmWJL4J6lxS8
         vhQ10CieL2ObdECt7G76bmvzQmfvC3NRkSsSTAp1cRJBpRYAjDYd1wMf9/6A359nKASx
         h8cw==
X-Gm-Message-State: AJIora+g7TpC8/jcqOj8mdurrz5O+i1hegui9LZaHMKS9JVnuBQwNVH5
        Lob9YU41Gv/rI7/qhzhuPbAZe7t3rRaUSotdMgRwshNPmPjF/YoM6E3ePFNBprA9BCPQ0UEhZs2
        KUvsQ4tLEXc1FEcVtyezSEh1tQhwgcXSgLxADVSzFj+iqa7RXVxLbfXZXhqv4uJMGcqxIgJY=
X-Received: by 2002:a17:903:2310:b0:16c:1546:19ba with SMTP id d16-20020a170903231000b0016c154619bamr3476158plh.57.1657723407997;
        Wed, 13 Jul 2022 07:43:27 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u3RU4p313wzrFwaIfL26jtnlBOnMgEKxIUrjeadJ1otDDhy0ufbBeooLLxKE0pIfNeacfebw==
X-Received: by 2002:a17:903:2310:b0:16c:1546:19ba with SMTP id d16-20020a170903231000b0016c154619bamr3476129plh.57.1657723407616;
        Wed, 13 Jul 2022 07:43:27 -0700 (PDT)
Received: from [10.72.14.22] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902cecb00b0016bd5da20casm9006989plg.134.2022.07.13.07.43.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 07:43:27 -0700 (PDT)
Subject: Re: [ceph-client:testing 1/21] fs/ceph/super.c:1101:46: error:
 'struct ceph_fs_client' has no member named 'fsc_dummy_enc_policy'
To:     kernel test robot <lkp@intel.com>, Jeff Layton <jlayton@kernel.org>
Cc:     kbuild-all@lists.01.org, ceph-devel@vger.kernel.org
References: <202207132003.QSn2r1BX-lkp@intel.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <14c59411-487c-1702-e09d-3a846ccffced@redhat.com>
Date:   Wed, 13 Jul 2022 22:43:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <202207132003.QSn2r1BX-lkp@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Thanks for this report.

Fixed it by:

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 4ac4a90755a2..0a60821db2c9 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1086,6 +1086,7 @@ static struct dentry *open_root_dentry(struct 
ceph_fs_client *fsc,
         return root;
  }

+#ifdef CONFIG_FS_ENCRYPTION
  static int ceph_apply_test_dummy_encryption(struct super_block *sb,
                                             struct fs_context *fc,
                                             struct ceph_mount_options 
*fsopt)
@@ -1127,6 +1128,14 @@ static int 
ceph_apply_test_dummy_encryption(struct super_block *sb,
         warnfc(fc, "test_dummy_encryption mode enabled");
         return 0;
  }
+#else
+static int ceph_apply_test_dummy_encryption(struct super_block *sb,
+                                           struct fs_context *fc,
+                                           struct ceph_mount_options 
*fsopt)
+{
+       return 0;
+}
+#endif

  /*
   * mount: join the ceph cluster, and open root directory.


On 7/13/22 9:06 PM, kernel test robot wrote:
> tree:   https://github.com/ceph/ceph-client.git testing
> head:   6720fad7ad85215b45fa7899478311d22ba5331a
> commit: f450dd288f2774012e8a4928c696192ed877a5c2 [1/21] ceph: implement -o test_dummy_encryption mount option
> config: sparc64-randconfig-r015-20220712 (https://download.01.org/0day-ci/archive/20220713/202207132003.QSn2r1BX-lkp@intel.com/config)
> compiler: sparc64-linux-gcc (GCC) 11.3.0
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # https://github.com/ceph/ceph-client/commit/f450dd288f2774012e8a4928c696192ed877a5c2
>          git remote add ceph-client https://github.com/ceph/ceph-client.git
>          git fetch --no-tags ceph-client testing
>          git checkout f450dd288f2774012e8a4928c696192ed877a5c2
>          # save the config file
>          mkdir build_dir && cp config build_dir/.config
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=sparc64 SHELL=/bin/bash fs/ceph/
>
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>     fs/ceph/super.c: In function 'ceph_apply_test_dummy_encryption':
>>> fs/ceph/super.c:1101:46: error: 'struct ceph_fs_client' has no member named 'fsc_dummy_enc_policy'
>      1101 |             !fscrypt_is_dummy_policy_set(&fsc->fsc_dummy_enc_policy)) {
>           |                                              ^~
>     fs/ceph/super.c:1103:54: error: 'struct ceph_fs_client' has no member named 'fsc_dummy_enc_policy'
>      1103 |                                                  &fsc->fsc_dummy_enc_policy))
>           |                                                      ^~
>     fs/ceph/super.c:1110:45: error: 'struct ceph_fs_client' has no member named 'fsc_dummy_enc_policy'
>      1110 |         if (fscrypt_is_dummy_policy_set(&fsc->fsc_dummy_enc_policy)) {
>           |                                             ^~
>     fs/ceph/super.c:1112:54: error: 'struct ceph_fs_client' has no member named 'fsc_dummy_enc_policy'
>      1112 |                                                  &fsc->fsc_dummy_enc_policy))
>           |                                                      ^~
>     fs/ceph/super.c:1118:12: error: 'struct ceph_fs_client' has no member named 'fsc_dummy_enc_policy'
>      1118 |         fsc->fsc_dummy_enc_policy = fsopt->dummy_enc_policy;
>           |            ^~
>     fs/ceph/super.c:1121:50: error: 'struct ceph_fs_client' has no member named 'fsc_dummy_enc_policy'
>      1121 |         err = fscrypt_add_test_dummy_key(sb, &fsc->fsc_dummy_enc_policy);
>           |                                                  ^~
>
>
> vim +1101 fs/ceph/super.c
>
>    1088	
>    1089	static int ceph_apply_test_dummy_encryption(struct super_block *sb,
>    1090						    struct fs_context *fc,
>    1091						    struct ceph_mount_options *fsopt)
>    1092	{
>    1093		struct ceph_fs_client *fsc = sb->s_fs_info;
>    1094		int err;
>    1095	
>    1096		if (!fscrypt_is_dummy_policy_set(&fsopt->dummy_enc_policy))
>    1097			return 0;
>    1098	
>    1099		/* No changing encryption context on remount. */
>    1100		if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE &&
>> 1101		    !fscrypt_is_dummy_policy_set(&fsc->fsc_dummy_enc_policy)) {
>    1102			if (fscrypt_dummy_policies_equal(&fsopt->dummy_enc_policy,
>    1103							 &fsc->fsc_dummy_enc_policy))
>    1104				return 0;
>    1105			errorfc(fc, "Can't set test_dummy_encryption on remount");
>    1106			return -EINVAL;
>    1107		}
>    1108	
>    1109		/* Also make sure fsopt doesn't contain a conflicting value. */
>    1110		if (fscrypt_is_dummy_policy_set(&fsc->fsc_dummy_enc_policy)) {
>    1111			if (fscrypt_dummy_policies_equal(&fsopt->dummy_enc_policy,
>    1112							 &fsc->fsc_dummy_enc_policy))
>    1113				return 0;
>    1114			errorfc(fc, "Conflicting test_dummy_encryption options");
>    1115			return -EINVAL;
>    1116		}
>    1117	
>    1118		fsc->fsc_dummy_enc_policy = fsopt->dummy_enc_policy;
>    1119		memset(&fsopt->dummy_enc_policy, 0, sizeof(fsopt->dummy_enc_policy));
>    1120	
>    1121		err = fscrypt_add_test_dummy_key(sb, &fsc->fsc_dummy_enc_policy);
>    1122		if (err) {
>    1123			errorfc(fc, "Error adding test dummy encryption key, %d", err);
>    1124			return err;
>    1125		}
>    1126	
>    1127		warnfc(fc, "test_dummy_encryption mode enabled");
>    1128		return 0;
>    1129	}
>    1130	
>

