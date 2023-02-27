Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61A536A360B
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Feb 2023 01:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjB0A6v (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Feb 2023 19:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjB0A6u (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 26 Feb 2023 19:58:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B9F67ED1
        for <ceph-devel@vger.kernel.org>; Sun, 26 Feb 2023 16:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677459485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A4USuhGAaYdalM/YMquTYsOlUxRcifyI855v9IYU0wM=;
        b=jQsISOKx7NL2KnJR5iJs5xJWqFyK6D54mzMdUBnEntHjpWHDoigK+LY42/GfjNA6X0LEwk
        DQuOzXQbeJ0FggqzL7Nrq1yB/o609lP9ThmvC+eesfwSatIZ6zzbuAj8hGuiJObH4JYnLV
        UJDpOzQ4U9I7aMrmap3uH6W6aE1imtE=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-399--bFzE5xuMUCp6V0idZl7nw-1; Sun, 26 Feb 2023 19:58:03 -0500
X-MC-Unique: -bFzE5xuMUCp6V0idZl7nw-1
Received: by mail-pg1-f198.google.com with SMTP id h19-20020a63f913000000b00502f20ab936so1149329pgi.20
        for <ceph-devel@vger.kernel.org>; Sun, 26 Feb 2023 16:58:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A4USuhGAaYdalM/YMquTYsOlUxRcifyI855v9IYU0wM=;
        b=pjPiuZBv4UcdFA5YN4dTxqckl1ZJJ/uUHUmy/Zyb4MPTB40O1zLXdOJkHBBMdx76bt
         Xh+IPkMB89MApxJKPUD2vvXQQV5ATbkaRwGVyQLxmx5U6258hnh8XHSn/8LBWz5OuxYW
         kRhZKW1z6ompX/GlNx21j0mglkV3Yu7PFFsexYE8rnuUIb4eGvoxzSRIS5uuvkSCRCIi
         SGquY2+jtdfY1aiOLPrbuiE/uwDkxz+h/h/DeCWRP5plbybTk0++2UIvHqIF7bxlOpCp
         cJTGN7SRyg0818lIFsUD0YubYkNo2BURoRzhEu77fyAhAIcz/1ikMssts3yWos9DgVGj
         gzgw==
X-Gm-Message-State: AO0yUKX5QakmUlv6GgCZT76A0Pm0je6qAAr0DEf3gHXqF+Hl1N4oIhgr
        TVSiDc15/swi4yBculI14brSexutxx+IH7I66odsHiq0QKoqpO6WaIJTTdp+yhTDD5cgcrvZOR/
        T3/4Fc27U46JiwSdLge2vCg==
X-Received: by 2002:a62:4ec9:0:b0:5ad:9f47:885b with SMTP id c192-20020a624ec9000000b005ad9f47885bmr18145009pfb.31.1677459482679;
        Sun, 26 Feb 2023 16:58:02 -0800 (PST)
X-Google-Smtp-Source: AK7set8hP9syJ5Iy7wQJRx+zMbG9YPE+mL4kB4D2ZmFaqyDbe64OALChkWFPjnPpDMqEH/jpESjj0A==
X-Received: by 2002:a62:4ec9:0:b0:5ad:9f47:885b with SMTP id c192-20020a624ec9000000b005ad9f47885bmr18144997pfb.31.1677459482310;
        Sun, 26 Feb 2023 16:58:02 -0800 (PST)
Received: from [10.72.12.136] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id m12-20020aa78a0c000000b005a8ae0c52cfsm3115332pfa.16.2023.02.26.16.57.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Feb 2023 16:58:01 -0800 (PST)
Message-ID: <f1b5ce5b-14d7-f8e5-4a72-ab139a031f25@redhat.com>
Date:   Mon, 27 Feb 2023 08:57:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [ceph-client:testing 32/75] fs/ceph/crypto.c:296:26: error:
 implicit declaration of function 'fscrypt_base64url_decode'; did you mean
 'ceph_base64_decode'?
To:     kernel test robot <lkp@intel.com>, Jeff Layton <jlayton@kernel.org>
Cc:     oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org,
        Ilya Dryomov <idryomov@gmail.com>
References: <202302270537.vINNROs9-lkp@intel.com>
Content-Language: en-US
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <202302270537.vINNROs9-lkp@intel.com>
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

Hi

Thanks very much for pointing this out.

This was introduced by an intermediate commit and I will revise it.

- Xiubo

On 27/02/2023 05:38, kernel test robot wrote:
> tree:   https://github.com/ceph/ceph-client.git testing
> head:   69aa49c89640a5018393d2ae30e5a6071e3cf9c8
> commit: 44947f44747cf0c16f0999962b4a43b6d8a2c6e8 [32/75] ceph: add helpers for converting names for userland presentation
> config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20230227/202302270537.vINNROs9-lkp@intel.com/config)
> compiler: sh4-linux-gcc (GCC) 12.1.0
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # https://github.com/ceph/ceph-client/commit/44947f44747cf0c16f0999962b4a43b6d8a2c6e8
>          git remote add ceph-client https://github.com/ceph/ceph-client.git
>          git fetch --no-tags ceph-client testing
>          git checkout 44947f44747cf0c16f0999962b4a43b6d8a2c6e8
>          # save the config file
>          mkdir build_dir && cp config build_dir/.config
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sh olddefconfig
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sh SHELL=/bin/bash fs/ceph/
>
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Link: https://lore.kernel.org/oe-kbuild-all/202302270537.vINNROs9-lkp@intel.com/
>
> Note: the ceph-client/testing HEAD 69aa49c89640a5018393d2ae30e5a6071e3cf9c8 builds fine.
>        It only hurts bisectability.
>
> All errors (new ones prefixed by >>):
>
>     fs/ceph/crypto.c: In function 'ceph_fname_to_usr':
>     fs/ceph/crypto.c:267:31: error: implicit declaration of function 'FSCRYPT_BASE64URL_CHARS'; did you mean 'CEPH_BASE64_CHARS'? [-Werror=implicit-function-declaration]
>       267 |         if (fname->name_len > FSCRYPT_BASE64URL_CHARS(NAME_MAX))
>           |                               ^~~~~~~~~~~~~~~~~~~~~~~
>           |                               CEPH_BASE64_CHARS
>>> fs/ceph/crypto.c:296:26: error: implicit declaration of function 'fscrypt_base64url_decode'; did you mean 'ceph_base64_decode'? [-Werror=implicit-function-declaration]
>       296 |                 declen = fscrypt_base64url_decode(fname->name, fname->name_len, tname->name);
>           |                          ^~~~~~~~~~~~~~~~~~~~~~~~
>           |                          ceph_base64_decode
>     cc1: some warnings being treated as errors
>
>
> vim +296 fs/ceph/crypto.c
>
>     237	
>     238	/**
>     239	 * ceph_fname_to_usr - convert a filename for userland presentation
>     240	 * @fname: ceph_fname to be converted
>     241	 * @tname: temporary name buffer to use for conversion (may be NULL)
>     242	 * @oname: where converted name should be placed
>     243	 * @is_nokey: set to true if key wasn't available during conversion (may be NULL)
>     244	 *
>     245	 * Given a filename (usually from the MDS), format it for presentation to
>     246	 * userland. If @parent is not encrypted, just pass it back as-is.
>     247	 *
>     248	 * Otherwise, base64 decode the string, and then ask fscrypt to format it
>     249	 * for userland presentation.
>     250	 *
>     251	 * Returns 0 on success or negative error code on error.
>     252	 */
>     253	int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
>     254			      struct fscrypt_str *oname, bool *is_nokey)
>     255	{
>     256		int ret;
>     257		struct fscrypt_str _tname = FSTR_INIT(NULL, 0);
>     258		struct fscrypt_str iname;
>     259	
>     260		if (!IS_ENCRYPTED(fname->dir)) {
>     261			oname->name = fname->name;
>     262			oname->len = fname->name_len;
>     263			return 0;
>     264		}
>     265	
>     266		/* Sanity check that the resulting name will fit in the buffer */
>     267		if (fname->name_len > FSCRYPT_BASE64URL_CHARS(NAME_MAX))
>     268			return -EIO;
>     269	
>     270		ret = __fscrypt_prepare_readdir(fname->dir);
>     271		if (ret)
>     272			return ret;
>     273	
>     274		/*
>     275		 * Use the raw dentry name as sent by the MDS instead of
>     276		 * generating a nokey name via fscrypt.
>     277		 */
>     278		if (!fscrypt_has_encryption_key(fname->dir)) {
>     279			memcpy(oname->name, fname->name, fname->name_len);
>     280			oname->len = fname->name_len;
>     281			if (is_nokey)
>     282				*is_nokey = true;
>     283			return 0;
>     284		}
>     285	
>     286		if (fname->ctext_len == 0) {
>     287			int declen;
>     288	
>     289			if (!tname) {
>     290				ret = fscrypt_fname_alloc_buffer(NAME_MAX, &_tname);
>     291				if (ret)
>     292					return ret;
>     293				tname = &_tname;
>     294			}
>     295	
>   > 296			declen = fscrypt_base64url_decode(fname->name, fname->name_len, tname->name);
>
-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li

