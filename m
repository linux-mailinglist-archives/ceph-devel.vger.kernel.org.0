Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4DA547844
	for <lists+ceph-devel@lfdr.de>; Sun, 12 Jun 2022 04:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbiFLC01 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 11 Jun 2022 22:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiFLC01 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 11 Jun 2022 22:26:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EE2FB69CDE
        for <ceph-devel@vger.kernel.org>; Sat, 11 Jun 2022 19:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655000784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Po+OITd9LduODB5Ll6LkiNrsN4yFiLHBsGMIZQJ3aw4=;
        b=aW1ltQKxrVGECY5gvRvXY+cGbzhFNn7qvKqGlFA/wi4h1qx6+YfILKNNZT9imPUo3RV7XF
        8zwmSdzI1YXAhJX1YZqQ3XXA9q77NvxuNIrl8VfLtJdO2gpXgvgFjwme10Hc824mOqr/9v
        hz3yRbPXEZlB2j7RCQZrIM/hB8XRIDk=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-472-QHt0r0JCMq-rAvGg08s7hw-1; Sat, 11 Jun 2022 22:26:23 -0400
X-MC-Unique: QHt0r0JCMq-rAvGg08s7hw-1
Received: by mail-pg1-f200.google.com with SMTP id n8-20020a635908000000b00401a7b6235bso1717428pgb.5
        for <ceph-devel@vger.kernel.org>; Sat, 11 Jun 2022 19:26:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Po+OITd9LduODB5Ll6LkiNrsN4yFiLHBsGMIZQJ3aw4=;
        b=WYuakp9SR2kn7znvZd2gTb0jPdlHyEWud+xik3aUoY4+hRTVgaNXlis5kTqNcsF3do
         7LnNRRfNXOEhXE8us9E4yqkqAUbZGSa5sWA2+O0AFrmlUbsfuzC3VAmyugimQ/aZ/Tre
         JeEZv/rxqgnDyjhTWNK7YaeWNuvD+uqwY3EUfeLcp9uVKvXgRfD2+7CWEg3HxVIs++7r
         cx28zwFqaF6Nr5QKT26+IslknY2Kd5ITpS6iYgt7u/KtRqB7o6lHjRssbEe3t3z4S4px
         0zI7ZsxUny75Bmu9vhfcAkGnEFOk9rtE04ZSmT9+enGwmkpyortVyHlIWTqTFL5QErl8
         LEsw==
X-Gm-Message-State: AOAM531j3EHzIIa1t2leQRZOfu7vPE/MhMgTB2FXJW74ZONM9Y+PzqQl
        HzS0VFJ0c74InSvIlYzPg9qJEnAlMdL8qw597QU2kPFN5SZ3krUSMNnAL8X2A4Td9Z6ZWj4/uOs
        eaKSQlQTShwxyQld6Ir7TmQ==
X-Received: by 2002:a17:902:7449:b0:167:9520:d063 with SMTP id e9-20020a170902744900b001679520d063mr26178528plt.146.1655000781884;
        Sat, 11 Jun 2022 19:26:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSUdWj0g6z3wcj79WuGy61sOTinJ+Xh99UhjKXW2wg576bkRRUKMKz5+wx7YOmEnrejlsPhA==
X-Received: by 2002:a17:902:7449:b0:167:9520:d063 with SMTP id e9-20020a170902744900b001679520d063mr26178517plt.146.1655000781571;
        Sat, 11 Jun 2022 19:26:21 -0700 (PDT)
Received: from [10.72.12.41] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s4-20020a170903200400b0016223016d79sm2188658pla.90.2022.06.11.19.26.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jun 2022 19:26:20 -0700 (PDT)
Subject: Re: [ceph-client:testing 7/9] lib/iov_iter.c:1464:9: warning:
 comparison of distinct pointer types ('typeof (nr * ((1UL) << (12)) - offset)
 *' (aka 'unsigned long *') and 'typeof (maxsize) *' (aka 'unsigned int *'))
To:     kernel test robot <lkp@intel.com>,
        David Howells <dhowells@redhat.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        ceph-devel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>
References: <202206112305.4DdsErK8-lkp@intel.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <a1a3edde-7b44-eb09-6695-e7c57356b96e@redhat.com>
Date:   Sun, 12 Jun 2022 10:26:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <202206112305.4DdsErK8-lkp@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Thanks for the warning report.

These was introduced by one DO NOT MEGE patch, which should go into 
mainline via David Howells's tree IMO.

-- Xiubo


On 6/11/22 11:10 PM, kernel test robot wrote:
> tree:   https://github.com/ceph/ceph-client.git testing
> head:   7b864d005b1f7f6a144420e180891b6401078407
> commit: 3adeefbfca0fd57cc943b7ec0330385f48041f0c [7/9] [DO NOT MERGE] iov_iter: Fix iter_xarray_get_pages{,_alloc}()
> config: riscv-randconfig-r034-20220611 (https://download.01.org/0day-ci/archive/20220611/202206112305.4DdsErK8-lkp@intel.com/config)
> compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project ff4abe755279a3a47cc416ef80dbc900d9a98a19)
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # install riscv cross compiling tool for clang build
>          # apt-get install binutils-riscv-linux-gnu
>          # https://github.com/ceph/ceph-client/commit/3adeefbfca0fd57cc943b7ec0330385f48041f0c
>          git remote add ceph-client https://github.com/ceph/ceph-client.git
>          git fetch --no-tags ceph-client testing
>          git checkout 3adeefbfca0fd57cc943b7ec0330385f48041f0c
>          # save the config file
>          mkdir build_dir && cp config build_dir/.config
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash
>
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>>> lib/iov_iter.c:1464:9: warning: comparison of distinct pointer types ('typeof (nr * ((1UL) << (12)) - offset) *' (aka 'unsigned long *') and 'typeof (maxsize) *' (aka 'unsigned int *')) [-Wcompare-distinct-pointer-types]
>             return min(nr * PAGE_SIZE - offset, maxsize);
>                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     include/linux/minmax.h:45:19: note: expanded from macro 'min'
>     #define min(x, y)       __careful_cmp(x, y, <)
>                             ^~~~~~~~~~~~~~~~~~~~~~
>     include/linux/minmax.h:36:24: note: expanded from macro '__careful_cmp'
>             __builtin_choose_expr(__safe_cmp(x, y), \
>                                   ^~~~~~~~~~~~~~~~
>     include/linux/minmax.h:26:4: note: expanded from macro '__safe_cmp'
>                     (__typecheck(x, y) && __no_side_effects(x, y))
>                      ^~~~~~~~~~~~~~~~~
>     include/linux/minmax.h:20:28: note: expanded from macro '__typecheck'
>             (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
>                        ~~~~~~~~~~~~~~ ^  ~~~~~~~~~~~~~~
>     lib/iov_iter.c:1628:9: warning: comparison of distinct pointer types ('typeof (nr * ((1UL) << (12)) - offset) *' (aka 'unsigned long *') and 'typeof (maxsize) *' (aka 'unsigned int *')) [-Wcompare-distinct-pointer-types]
>             return min(nr * PAGE_SIZE - offset, maxsize);
>                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     include/linux/minmax.h:45:19: note: expanded from macro 'min'
>     #define min(x, y)       __careful_cmp(x, y, <)
>                             ^~~~~~~~~~~~~~~~~~~~~~
>     include/linux/minmax.h:36:24: note: expanded from macro '__careful_cmp'
>             __builtin_choose_expr(__safe_cmp(x, y), \
>                                   ^~~~~~~~~~~~~~~~
>     include/linux/minmax.h:26:4: note: expanded from macro '__safe_cmp'
>                     (__typecheck(x, y) && __no_side_effects(x, y))
>                      ^~~~~~~~~~~~~~~~~
>     include/linux/minmax.h:20:28: note: expanded from macro '__typecheck'
>             (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
>                        ~~~~~~~~~~~~~~ ^  ~~~~~~~~~~~~~~
>     2 warnings generated.
>
>
> vim +1464 lib/iov_iter.c
>
>    1430	
>    1431	static ssize_t iter_xarray_get_pages(struct iov_iter *i,
>    1432					     struct page **pages, size_t maxsize,
>    1433					     unsigned maxpages, size_t *_start_offset)
>    1434	{
>    1435		unsigned nr, offset;
>    1436		pgoff_t index, count;
>    1437		size_t size = maxsize;
>    1438		loff_t pos;
>    1439	
>    1440		if (!size || !maxpages)
>    1441			return 0;
>    1442	
>    1443		pos = i->xarray_start + i->iov_offset;
>    1444		index = pos >> PAGE_SHIFT;
>    1445		offset = pos & ~PAGE_MASK;
>    1446		*_start_offset = offset;
>    1447	
>    1448		count = 1;
>    1449		if (size > PAGE_SIZE - offset) {
>    1450			size -= PAGE_SIZE - offset;
>    1451			count += size >> PAGE_SHIFT;
>    1452			size &= ~PAGE_MASK;
>    1453			if (size)
>    1454				count++;
>    1455		}
>    1456	
>    1457		if (count > maxpages)
>    1458			count = maxpages;
>    1459	
>    1460		nr = iter_xarray_populate_pages(pages, i->xarray, index, count);
>    1461		if (nr == 0)
>    1462			return 0;
>    1463	
>> 1464		return min(nr * PAGE_SIZE - offset, maxsize);
>    1465	}
>    1466	
>

