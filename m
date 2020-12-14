Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1322D9D77
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Dec 2020 18:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388520AbgLNRT5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Dec 2020 12:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731155AbgLNRT5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 14 Dec 2020 12:19:57 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71027C0613D3
        for <ceph-devel@vger.kernel.org>; Mon, 14 Dec 2020 09:19:17 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id r17so16473299ilo.11
        for <ceph-devel@vger.kernel.org>; Mon, 14 Dec 2020 09:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XF2vYpkUhqVFEWRY/EuuaPoCF9fMxTqRVKu1q30TqjU=;
        b=gbpmaxVUQ+BwXBs2LqZKQeTqscM9t6yI9zARGkQRSBCpJmGqgYUqRjIE0t7kHu8y3y
         g9cSTX71lRtoTq2omLFp9o8e9q2n/yMcbxf1vWM9TCHI4lOjz5jkFhTAi6IoAphfF4xH
         8fsWjeeTpfwvAZZ9IhqpA2kT0vAnJZSzGcYM3I+W29b52BiBw44gYkBCU1Zh1gLRzCIH
         8uRTrZQ/rZDVauLdoopgTHFQXu3p5r9YK4V2kW5q5/QfgCdL1yA/JEtTEHlQ4zgM+8Q0
         CkwvwzUZZdwjVCWV1ZLGLwRAfHScm/c+MRDdzuDtPCSB3xtJiaLnhPvE12a0O98vaRJR
         9Cuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XF2vYpkUhqVFEWRY/EuuaPoCF9fMxTqRVKu1q30TqjU=;
        b=ny7JyXI+bbXpA0vmTctPAWufTDQQhi3fJQ1lma3sd9jkkUx9NeU/ZYkxeE+YLynYXk
         ifQZ5qcZ9pbgEmOwDeuKLIbW3LaCtF633TG9idPQMl7iQ82g9C3fhWA0SVRiOiM2EAbu
         AYEpubLGehd6o78CUQSZQZ5VP2Ffvc8KAoRFkQ0qyiKi1hfJcn8/s2SWyCb0XhL1zB9V
         REg6FI0n6UCS2gnLEp+yzuhFettRkPDpg6NkA5XeNYWSHycTjDEWe8ImgcD2niIe0SGn
         77uxua8E9OUEihix8bKDdZoJ+PQqpkR93JtfJJwyTRYUt5KrYv5RK5OlehPMrvGkIQUT
         HePQ==
X-Gm-Message-State: AOAM533tVv9JaHnwVGbSukfH2hYqXqJL4vNuBi/Gb+YU1rQkmd+OU4/B
        iJbnXzcSgFQLvUF7GAolJZ4QOrCnRU1OKlsDiUk=
X-Google-Smtp-Source: ABdhPJxdi/GqwgJKTyV3aciygPPf86zjeA6Qj9ngPxVC5pXSdtcCLnntfUhl4d7VPuVluA5/2gDkDe5xYQYo1oVLFCU=
X-Received: by 2002:a92:4c3:: with SMTP id 186mr36498564ile.177.1607966356797;
 Mon, 14 Dec 2020 09:19:16 -0800 (PST)
MIME-Version: 1.0
References: <202012142233.a4thz4WN-lkp@intel.com>
In-Reply-To: <202012142233.a4thz4WN-lkp@intel.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 14 Dec 2020 18:19:05 +0100
Message-ID: <CAOi1vP_zeSnm_oKph9+T0qc+tMvHNoFepY7rFGrj+cFSskh3Ug@mail.gmail.com>
Subject: Re: [ceph-client:pr/22 32/34] net/ceph/messenger_v2.c:601:24: sparse:
 sparse: incorrect type in assignment (different base types)
To:     kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Dec 14, 2020 at 3:28 PM kernel test robot <lkp@intel.com> wrote:
>
> tree:   https://github.com/ceph/ceph-client.git pr/22
> head:   524d1e6601a7d1214c502d5739f5a34f09a0960c
> commit: 48b7789934f0e94b975e98b74eaf18301fc0cfcd [32/34] libceph: implement msgr2.1 protocol (crc and secure modes)
> config: alpha-randconfig-s032-20201214 (attached as .config)
> compiler: alpha-linux-gcc (GCC) 9.3.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # apt-get install sparse
>         # sparse version: v0.6.3-184-g1b896707-dirty
>         # https://github.com/ceph/ceph-client/commit/48b7789934f0e94b975e98b74eaf18301fc0cfcd
>         git remote add ceph-client https://github.com/ceph/ceph-client.git
>         git fetch --no-tags ceph-client pr/22
>         git checkout 48b7789934f0e94b975e98b74eaf18301fc0cfcd
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=alpha
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
>
> "sparse warnings: (new ones prefixed by >>)"
> >> net/ceph/messenger_v2.c:601:24: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [usertype] front_len @@     got int front_len @@
>    net/ceph/messenger_v2.c:601:24: sparse:     expected restricted __le32 [usertype] front_len
>    net/ceph/messenger_v2.c:601:24: sparse:     got int front_len
> >> net/ceph/messenger_v2.c:602:25: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [usertype] middle_len @@     got int middle_len @@
>    net/ceph/messenger_v2.c:602:25: sparse:     expected restricted __le32 [usertype] middle_len
>    net/ceph/messenger_v2.c:602:25: sparse:     got int middle_len
> >> net/ceph/messenger_v2.c:603:23: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [usertype] data_len @@     got int data_len @@
>    net/ceph/messenger_v2.c:603:23: sparse:     expected restricted __le32 [usertype] data_len
>    net/ceph/messenger_v2.c:603:23: sparse:     got int data_len
>
> vim +601 net/ceph/messenger_v2.c
>
>    590
>    591  static void fill_header(struct ceph_msg_header *hdr,
>    592                          const struct ceph_msg_header2 *hdr2,
>    593                          int front_len, int middle_len, int data_len,
>    594                          const struct ceph_entity_name *peer_name)
>    595  {
>    596          hdr->seq = hdr2->seq;
>    597          hdr->tid = hdr2->tid;
>    598          hdr->type = hdr2->type;
>    599          hdr->priority = hdr2->priority;
>    600          hdr->version = hdr2->version;
>  > 601          hdr->front_len = front_len;
>  > 602          hdr->middle_len = middle_len;
>  > 603          hdr->data_len = data_len;
>    604          hdr->data_off = hdr2->data_off;
>    605          hdr->src = *peer_name;
>    606          hdr->compat_version = hdr2->compat_version;
>    607          hdr->reserved = 0;
>    608          hdr->crc = 0;
>    609  }
>    610
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

Fixed.

Thanks,

                Ilya
