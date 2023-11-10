Return-Path: <ceph-devel+bounces-77-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C3FC7E7608
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Nov 2023 01:45:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BF722B2101F
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Nov 2023 00:45:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0756628;
	Fri, 10 Nov 2023 00:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ObOYjjzQ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7355F627
	for <ceph-devel@vger.kernel.org>; Fri, 10 Nov 2023 00:45:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B518830EA
	for <ceph-devel@vger.kernel.org>; Thu,  9 Nov 2023 16:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699577107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O5T+8idnS6WiaO5uSOEZcqcU3gG2BIpvoUbMSw4APFw=;
	b=ObOYjjzQ911tC0BQTNrkBuaIvG6h7AiUzCcDtSF7/e0HZIenChTPqeaUZUe0R703/ZOi8R
	iq5+YEcXv9lDke8s6Y6okOCDu3pwXeGrqtJfwGvPUqEYic9fR+O/x6Oic7yJej54kqLqBp
	H43qB5KuKOooouoHMCsaWxEAmVsrQEA=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222-L-utjTXJOS66UUmTHqwktw-1; Thu, 09 Nov 2023 19:45:06 -0500
X-MC-Unique: L-utjTXJOS66UUmTHqwktw-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-5b7dfda133dso1433479a12.0
        for <ceph-devel@vger.kernel.org>; Thu, 09 Nov 2023 16:45:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699577105; x=1700181905;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O5T+8idnS6WiaO5uSOEZcqcU3gG2BIpvoUbMSw4APFw=;
        b=LxOfCGkLSOjKMiPam6XOYsts8tQ7pk/sC9Wx5FufQEJOubzJlQn16M6kP6Nlfon+Kp
         M6iUuNM7qlcskjqL3EPSBgnk1vThooD7NwjQ7FhxT/VtL6N/lZYphL8VIHKm17lAeNxK
         giA00eb+TrTL/Cewik84q9Tmt7jLkXTa7g+H9CftQ2W1gjKmH3Iyp7Ndg2iuqERbN2Ra
         DVkBFibqSjJzywMNoJzyS9Gge9IYvpNKHaYm3RcsATy3ybsJxlVC/NnQzo/1Axb4FDPc
         Ld8eSKZaIxIFye4UM3K74L3zbzWqufX67DUgpbb+26UUjkBAFFH8DMc/GlXngubL7ftX
         Kz8A==
X-Gm-Message-State: AOJu0Yz/4yEVJBeGfMaUVpuvsH808ecHGbX8DawngOgkyIUmiCvse18/
	Ilr18lKfCSLwexcGs8nVM8QcdeQx+2LHkW9kSRNzHWGDox1n6TlIddHEWY8d+Hz2FkSlopBZZjI
	dr6UZIRRz3pBOuwBwnOLZKg==
X-Received: by 2002:a05:6a20:e11b:b0:181:219f:4a6a with SMTP id kr27-20020a056a20e11b00b00181219f4a6amr8539185pzb.49.1699577104856;
        Thu, 09 Nov 2023 16:45:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHlISqlH4FKpBdjh552al6Q5uyYXgxKKDzEhPXefq1IvQon2P+YZXh4Ysos9oa4K6oDbkR4sA==
X-Received: by 2002:a05:6a20:e11b:b0:181:219f:4a6a with SMTP id kr27-20020a056a20e11b00b00181219f4a6amr8539171pzb.49.1699577104460;
        Thu, 09 Nov 2023 16:45:04 -0800 (PST)
Received: from [10.72.112.221] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id h15-20020aa786cf000000b006c06779e593sm11724046pfo.16.2023.11.09.16.45.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Nov 2023 16:45:04 -0800 (PST)
Message-ID: <b91a9c36-3709-0449-3c89-aa733cfe67d4@redhat.com>
Date: Fri, 10 Nov 2023 08:45:00 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [ceph-client:testing 5/17] include/linux/kern_levels.h:5:25:
 warning: format '%s' expects argument of type 'char *', but argument 5 has
 type 'u32' {aka 'unsigned int'}
Content-Language: en-US
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
References: <202311100323.X2ldielo-lkp@intel.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <202311100323.X2ldielo-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Thanks for reporting this. I fixed the testing branch.

Cheers.

- Xiubo

On 11/10/23 04:10, kernel test robot wrote:
> tree:   https://github.com/ceph/ceph-client.git testing
> head:   df68d14f678dc8f70ab1dc9cb4f1257af7b7d91b
> commit: c67942de8d2ccb3f1a8d1b87908f679be5a9d6a3 [5/17] [DO NOT MERGE] ceph: BUG if MDS changed truncate_seq with client caps still outstanding
> config: i386-randconfig-006-20231110 (https://download.01.org/0day-ci/archive/20231110/202311100323.X2ldielo-lkp@intel.com/config)
> compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231110/202311100323.X2ldielo-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202311100323.X2ldielo-lkp@intel.com/
>
> All warnings (new ones prefixed by >>):
>
>           |         ^~~~~~
>     fs/ceph/inode.c:789:33: note: in expansion of macro 'pr_err_client'
>       789 |                                 pr_err_client(" truncate_seq %u -> %u\n",
>           |                                 ^~~~~~~~~~~~~
>     include/linux/kern_levels.h:5:25: warning: format '%llu' expects a matching 'long long unsigned int' argument [-Wformat=]
>         5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
>           |                         ^~~~~~
>     include/linux/printk.h:427:25: note: in definition of macro 'printk_index_wrap'
>       427 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
>           |                         ^~~~
>     include/linux/printk.h:498:9: note: in expansion of macro 'printk'
>       498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
>           |         ^~~~~~
>     include/linux/kern_levels.h:11:25: note: in expansion of macro 'KERN_SOH'
>        11 | #define KERN_ERR        KERN_SOH "3"    /* error conditions */
>           |                         ^~~~~~~~
>     include/linux/printk.h:498:16: note: in expansion of macro 'KERN_ERR'
>       498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
>           |                ^~~~~~~~
>     include/linux/ceph/ceph_debug.h:68:9: note: in expansion of macro 'pr_err'
>        68 |         pr_err("[%pU %llu]: " fmt, &client->fsid,                       \
>           |         ^~~~~~
>     fs/ceph/inode.c:789:33: note: in expansion of macro 'pr_err_client'
>       789 |                                 pr_err_client(" truncate_seq %u -> %u\n",
>           |                                 ^~~~~~~~~~~~~
>     fs/ceph/inode.c:791:72: error: expected ')' before 'isize'
>       791 |                                 pr_err_client("  size %lld -> %llu\n", isize, size);
>           |                                                                        ^~~~~
>     include/linux/printk.h:427:25: note: in definition of macro 'printk_index_wrap'
>       427 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
>           |                         ^~~~
>     include/linux/printk.h:498:9: note: in expansion of macro 'printk'
>       498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
>           |         ^~~~~~
>     include/linux/printk.h:498:25: note: in expansion of macro 'pr_fmt'
>       498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
>           |                         ^~~~~~
>     include/linux/ceph/ceph_debug.h:68:9: note: in expansion of macro 'pr_err'
>        68 |         pr_err("[%pU %llu]: " fmt, &client->fsid,                       \
>           |         ^~~~~~
>     fs/ceph/inode.c:791:33: note: in expansion of macro 'pr_err_client'
>       791 |                                 pr_err_client("  size %lld -> %llu\n", isize, size);
>           |                                 ^~~~~~~~~~~~~
>     include/linux/printk.h:427:24: note: to match this '('
>       427 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
>           |                        ^
>     include/linux/printk.h:455:26: note: in expansion of macro 'printk_index_wrap'
>       455 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
>           |                          ^~~~~~~~~~~~~~~~~
>     include/linux/printk.h:498:9: note: in expansion of macro 'printk'
>       498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
>           |         ^~~~~~
>     include/linux/ceph/ceph_debug.h:68:9: note: in expansion of macro 'pr_err'
>        68 |         pr_err("[%pU %llu]: " fmt, &client->fsid,                       \
>           |         ^~~~~~
>     fs/ceph/inode.c:791:33: note: in expansion of macro 'pr_err_client'
>       791 |                                 pr_err_client("  size %lld -> %llu\n", isize, size);
>           |                                 ^~~~~~~~~~~~~
>     include/linux/kern_levels.h:5:25: warning: format '%p' expects a matching 'void *' argument [-Wformat=]
>         5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
>           |                         ^~~~~~
>     include/linux/printk.h:427:25: note: in definition of macro 'printk_index_wrap'
>       427 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
>           |                         ^~~~
>     include/linux/printk.h:498:9: note: in expansion of macro 'printk'
>       498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
>           |         ^~~~~~
>     include/linux/kern_levels.h:11:25: note: in expansion of macro 'KERN_SOH'
>        11 | #define KERN_ERR        KERN_SOH "3"    /* error conditions */
>           |                         ^~~~~~~~
>     include/linux/printk.h:498:16: note: in expansion of macro 'KERN_ERR'
>       498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
>           |                ^~~~~~~~
>     include/linux/ceph/ceph_debug.h:68:9: note: in expansion of macro 'pr_err'
>        68 |         pr_err("[%pU %llu]: " fmt, &client->fsid,                       \
>           |         ^~~~~~
>     fs/ceph/inode.c:791:33: note: in expansion of macro 'pr_err_client'
>       791 |                                 pr_err_client("  size %lld -> %llu\n", isize, size);
>           |                                 ^~~~~~~~~~~~~
>     include/linux/kern_levels.h:5:25: warning: format '%llu' expects a matching 'long long unsigned int' argument [-Wformat=]
>         5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
>           |                         ^~~~~~
>     include/linux/printk.h:427:25: note: in definition of macro 'printk_index_wrap'
>       427 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
>           |                         ^~~~
>     include/linux/printk.h:498:9: note: in expansion of macro 'printk'
>       498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
>           |         ^~~~~~
>     include/linux/kern_levels.h:11:25: note: in expansion of macro 'KERN_SOH'
>        11 | #define KERN_ERR        KERN_SOH "3"    /* error conditions */
>           |                         ^~~~~~~~
>     include/linux/printk.h:498:16: note: in expansion of macro 'KERN_ERR'
>       498 |         printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
>           |                ^~~~~~~~
>     include/linux/ceph/ceph_debug.h:68:9: note: in expansion of macro 'pr_err'
>        68 |         pr_err("[%pU %llu]: " fmt, &client->fsid,                       \
>           |         ^~~~~~
>     fs/ceph/inode.c:791:33: note: in expansion of macro 'pr_err_client'
>       791 |                                 pr_err_client("  size %lld -> %llu\n", isize, size);
>           |                                 ^~~~~~~~~~~~~
>>> include/linux/kern_levels.h:5:25: warning: format '%s' expects argument of type 'char *', but argument 5 has type 'u32' {aka 'unsigned int'} [-Wformat=]
>         5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
>           |                         ^~~~~~
>     include/linux/printk.h:427:25: note: in definition of macro 'printk_index_wrap'
>       427 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
>           |                         ^~~~
>     include/linux/printk.h:129:17: note: in expansion of macro 'printk'
>       129 |                 printk(fmt, ##__VA_ARGS__);             \
>           |                 ^~~~~~
>     include/linux/printk.h:585:9: note: in expansion of macro 'no_printk'
>       585 |         no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
>           |         ^~~~~~~~~
>     include/linux/kern_levels.h:15:25: note: in expansion of macro 'KERN_SOH'
>        15 | #define KERN_DEBUG      KERN_SOH "7"    /* debug-level messages */
>           |                         ^~~~~~~~
>     include/linux/printk.h:585:19: note: in expansion of macro 'KERN_DEBUG'
>       585 |         no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
>           |                   ^~~~~~~~~~
>     include/linux/ceph/ceph_debug.h:50:9: note: in expansion of macro 'pr_debug'
>        50 |         pr_debug(" [%pU %llu] %s: " fmt, &client->fsid,                 \
>           |         ^~~~~~~~
>     fs/ceph/inode.c:794:25: note: in expansion of macro 'doutc'
>       794 |                         doutc(cl, "%s truncate_seq %u -> %u\n",
>           |                         ^~~~~
>>> include/linux/kern_levels.h:5:25: warning: format '%u' expects a matching 'unsigned int' argument [-Wformat=]
>         5 | #define KERN_SOH        "\001"          /* ASCII Start Of Header */
>           |                         ^~~~~~
>     include/linux/printk.h:427:25: note: in definition of macro 'printk_index_wrap'
>       427 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
>           |                         ^~~~
>     include/linux/printk.h:129:17: note: in expansion of macro 'printk'
>       129 |                 printk(fmt, ##__VA_ARGS__);             \
>           |                 ^~~~~~
>     include/linux/printk.h:585:9: note: in expansion of macro 'no_printk'
>       585 |         no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
>           |         ^~~~~~~~~
>     include/linux/kern_levels.h:15:25: note: in expansion of macro 'KERN_SOH'
>        15 | #define KERN_DEBUG      KERN_SOH "7"    /* debug-level messages */
>           |                         ^~~~~~~~
>     include/linux/printk.h:585:19: note: in expansion of macro 'KERN_DEBUG'
>       585 |         no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
>           |                   ^~~~~~~~~~
>     include/linux/ceph/ceph_debug.h:50:9: note: in expansion of macro 'pr_debug'
>        50 |         pr_debug(" [%pU %llu] %s: " fmt, &client->fsid,                 \
>           |         ^~~~~~~~
>     fs/ceph/inode.c:794:25: note: in expansion of macro 'doutc'
>       794 |                         doutc(cl, "%s truncate_seq %u -> %u\n",
>           |                         ^~~~~
>
>
> vim +5 include/linux/kern_levels.h
>
> 314ba3520e513a Joe Perches 2012-07-30  4
> 04d2c8c83d0e3a Joe Perches 2012-07-30 @5  #define KERN_SOH	"\001"		/* ASCII Start Of Header */
> 04d2c8c83d0e3a Joe Perches 2012-07-30  6  #define KERN_SOH_ASCII	'\001'
> 04d2c8c83d0e3a Joe Perches 2012-07-30  7
>
> :::::: The code at line 5 was first introduced by commit
> :::::: 04d2c8c83d0e3ac5f78aeede51babb3236200112 printk: convert the format for KERN_<LEVEL> to a 2 byte pattern
>
> :::::: TO: Joe Perches <joe@perches.com>
> :::::: CC: Linus Torvalds <torvalds@linux-foundation.org>
>


