Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09ED72D9D82
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Dec 2020 18:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408432AbgLNRVG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Dec 2020 12:21:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732189AbgLNRVA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 14 Dec 2020 12:21:00 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36A2C0613D3
        for <ceph-devel@vger.kernel.org>; Mon, 14 Dec 2020 09:20:19 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id q1so16527824ilt.6
        for <ceph-devel@vger.kernel.org>; Mon, 14 Dec 2020 09:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cfV7hd9N4JxpeN97g/gwoYAB0o7GZEpLoKiwk6PfEzc=;
        b=dbG9gl79RxZDkcG2RTmKfWnhiBQuX0yYdvQot/wmaQ5UggvMPdoNkBN4Jngk97IVMd
         39+GaXzBLdY1jLN+lclv8ZSjvgI+p+IdK5fxyrbz80q0+cV1+SjFrU7IJMfqqd79yX5N
         2Z8Yv84xqaI+wv+GCxWK6kWmE+80DrX0LBTpd/zjU9xIDrLyaxtlV459jYWqik4ISP7v
         EEjOtL73dJSbjRPSWcDFW5Q8JtVz2m3T3bR2EqSj6hfuei/xeDw4onFlPbwVmEpRpTuG
         nQT+DiNLBwf2XKOpC0H3WaePupYEjKHuGaD81/pVCCiKyyrf6+4jp5gMjM2EvUEXtqNm
         rojA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cfV7hd9N4JxpeN97g/gwoYAB0o7GZEpLoKiwk6PfEzc=;
        b=Duntfg67P8XG5WZIBRqa/Quf+FHOB3LcYJDuhP6MhYBRnWgnnDNsZ+yCY3umxTWRIX
         1igJEcn9RExRM4LKrxgZekjoADhH5Ly+nG0Xe15CkhVcBY9xu288Pylmh2/E+zlShnhR
         V4n804+rwGB1jjBWsNJgRZfIETDOtUQJ23HFWeU+7K/1X39ObapO6Xkus2iImGBshHWC
         mZlRf+wGCIPPO6He6DQC5m48U36C6fgocXGjrKSM32crBLqdi3P4HWkibBY8KMwsFCkx
         h7Yi1tSjkrYXuTnTI9eZGQxGJv4nZs56xkXkTHcUm4OYnnHKifDw6oxbNO53zpJK+L+C
         Sy4w==
X-Gm-Message-State: AOAM532ObD6m6PZA4wE418vkj8G+WReBXIG0hLX3rBdR/rbhPYWqx2Sj
        9F64eUpFYiRKi4zRSnGT5XP6mBcKXnyMDxKVoVmtDx6cqa0=
X-Google-Smtp-Source: ABdhPJzqhVJ//W/WatkaliSX7HeRJ0xQT3uxjsGPq5vadb8tDi0bKEKYixiYIaxXbOcenE5WnZrmu8ZWq4l78X/5AQ0=
X-Received: by 2002:a92:8419:: with SMTP id l25mr36252513ild.100.1607966419099;
 Mon, 14 Dec 2020 09:20:19 -0800 (PST)
MIME-Version: 1.0
References: <202012142332.d8Oe1kY4-lkp@intel.com>
In-Reply-To: <202012142332.d8Oe1kY4-lkp@intel.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 14 Dec 2020 18:20:07 +0100
Message-ID: <CAOi1vP8yBv8ZCX=8mT49AdCY3R10DsqYFyHSw+5+fa=t3VwHYg@mail.gmail.com>
Subject: Re: [ceph-client:pr/22 32/34] include/linux/ceph/msgr.h:43:1:
 warning: 'static' is not at beginning of declaration
To:     kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Dec 14, 2020 at 4:33 PM kernel test robot <lkp@intel.com> wrote:
>
> tree:   https://github.com/ceph/ceph-client.git pr/22
> head:   524d1e6601a7d1214c502d5739f5a34f09a0960c
> commit: 48b7789934f0e94b975e98b74eaf18301fc0cfcd [32/34] libceph: implement msgr2.1 protocol (crc and secure modes)
> config: arm-randconfig-r006-20201214 (attached as .config)
> compiler: arm-linux-gnueabi-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/ceph/ceph-client/commit/48b7789934f0e94b975e98b74eaf18301fc0cfcd
>         git remote add ceph-client https://github.com/ceph/ceph-client.git
>         git fetch --no-tags ceph-client pr/22
>         git checkout 48b7789934f0e94b975e98b74eaf18301fc0cfcd
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=arm
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>    In file included from include/linux/ceph/ceph_fs.h:16,
>                     from include/linux/ceph/types.h:11,
>                     from include/linux/ceph/libceph.h:20,
>                     from drivers/block/rbd.c:31:
> >> include/linux/ceph/msgr.h:43:1: warning: 'static' is not at beginning of declaration [-Wold-style-declaration]
>       43 | DEFINE_MSGR2_FEATURE( 0, 1, REVISION_1)   // msgr2.1
>          | ^~~~~~~~~~~~~~~~~~~~
> >> include/linux/ceph/msgr.h:43:1: warning: 'static' is not at beginning of declaration [-Wold-style-declaration]
>    include/linux/ceph/msgr.h:37:24: warning: 'CEPH_MSGR2_FEATUREMASK_REVISION_1' defined but not used [-Wunused-const-variable=]
>       37 |  const static uint64_t CEPH_MSGR2_FEATUREMASK_##name =            \
>          |                        ^~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/ceph/msgr.h:43:1: note: in expansion of macro 'DEFINE_MSGR2_FEATURE'
>       43 | DEFINE_MSGR2_FEATURE( 0, 1, REVISION_1)   // msgr2.1
>          | ^~~~~~~~~~~~~~~~~~~~
>    include/linux/ceph/msgr.h:36:24: warning: 'CEPH_MSGR2_FEATURE_REVISION_1' defined but not used [-Wunused-const-variable=]
>       36 |  const static uint64_t CEPH_MSGR2_FEATURE_##name = (1ULL << bit); \
>          |                        ^~~~~~~~~~~~~~~~~~~
>    include/linux/ceph/msgr.h:43:1: note: in expansion of macro 'DEFINE_MSGR2_FEATURE'
>       43 | DEFINE_MSGR2_FEATURE( 0, 1, REVISION_1)   // msgr2.1
>          | ^~~~~~~~~~~~~~~~~~~~
> --
>    In file included from include/linux/ceph/ceph_fs.h:16,
>                     from include/linux/ceph/types.h:11,
>                     from include/linux/ceph/decode.h:11,
>                     from net/ceph/messenger_v2.c:24:
> >> include/linux/ceph/msgr.h:43:1: warning: 'static' is not at beginning of declaration [-Wold-style-declaration]
>       43 | DEFINE_MSGR2_FEATURE( 0, 1, REVISION_1)   // msgr2.1
>          | ^~~~~~~~~~~~~~~~~~~~
> >> include/linux/ceph/msgr.h:43:1: warning: 'static' is not at beginning of declaration [-Wold-style-declaration]
>    include/linux/ceph/msgr.h:37:24: warning: 'CEPH_MSGR2_FEATUREMASK_REVISION_1' defined but not used [-Wunused-const-variable=]
>       37 |  const static uint64_t CEPH_MSGR2_FEATUREMASK_##name =            \
>          |                        ^~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/ceph/msgr.h:43:1: note: in expansion of macro 'DEFINE_MSGR2_FEATURE'
>       43 | DEFINE_MSGR2_FEATURE( 0, 1, REVISION_1)   // msgr2.1
>          | ^~~~~~~~~~~~~~~~~~~~
>
> vim +/static +43 include/linux/ceph/msgr.h
>
>     34
>     35  #define DEFINE_MSGR2_FEATURE(bit, incarnation, name)               \
>     36          const static uint64_t CEPH_MSGR2_FEATURE_##name = (1ULL << bit); \
>     37          const static uint64_t CEPH_MSGR2_FEATUREMASK_##name =            \
>     38                          (1ULL << bit | CEPH_MSGR2_INCARNATION_##incarnation);
>     39
>     40  #define HAVE_MSGR2_FEATURE(x, name) \
>     41          (((x) & (CEPH_MSGR2_FEATUREMASK_##name)) == (CEPH_MSGR2_FEATUREMASK_##name))
>     42
>   > 43  DEFINE_MSGR2_FEATURE( 0, 1, REVISION_1)   // msgr2.1
>     44
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

This came from a userspace header.  Fixed.

Thanks,

                Ilya
