Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF12B26D774
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Sep 2020 11:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgIQJQh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Sep 2020 05:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgIQJQf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 17 Sep 2020 05:16:35 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF479C06174A
        for <ceph-devel@vger.kernel.org>; Thu, 17 Sep 2020 02:16:34 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id h2so1542844ilo.12
        for <ceph-devel@vger.kernel.org>; Thu, 17 Sep 2020 02:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3hX9WIJ93Hx7pW2OqifIhkigBlDw3PE5r8CbRztZfxY=;
        b=SDnnw2K1SKpalKVBddJ/plnNBxgJg8hR6Trwve6dnJYEuFIObr/gjtYT1MwaHj3TX5
         EhZQ5Cuabrt8Neu0v3IdV9GHWJQ9O/oCWru164BIIbPzzu3CEhtAG5URjyuCzaist3Kh
         SpBxriuK2dkk3Uu0N6KdFfLP2bWmJ+rB7JJOMrIU3iAIJJSuO0BF/92kUfREJ0j1RKFp
         oLn6Nubfuf9VHiG9GwqFIqqgTP8vvQdZ6pljXL2s9lQyyFKjHYkkh4Ql7dIIVFnNs4wt
         DyAxDdFeQCDs+mrlLWUGoYLq9aaxhIcJKw/i8YBzOEBycN5OUHaRpFErS9FRXT3IkaoS
         zNAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3hX9WIJ93Hx7pW2OqifIhkigBlDw3PE5r8CbRztZfxY=;
        b=CGCOgppcXGvdrgxiiBZIpiP0fkgKEDjxgKCHlAB6Tv5zzlYfTP/lZt2wXiOHAQuJwO
         1iCWfmQSeYFWjAFGWNUFiTLOVZF+hYPlvOQJwOgquGgW33HA5j6+ARkPxPVDPMFU3V3p
         a0ciXgLhUzAEK9eMAl1Pb/EWVqvTx8v+4kICGv1NgOKENWW3f2Wz9HuU0tsYaDvjDv4F
         IMKcjecU8qhZX2ZNMpMPlPFNX5jgwEUAqE8qSce6f4SJDTbAZimErNMEfgHzcC7CVSHB
         E6Jjg8eaj10HvjRz9LfMVxbr0yxnc4tFXARcUwYATTCXhWMqhx80l1KUjhN3M5bmVFed
         Snzw==
X-Gm-Message-State: AOAM533UpbPw3StB3MVbVrpq4biE6PDyLQDLbkBkbFcprUaQ5VakWoP+
        KocKUKVfOTvHQ+y0VVtJuhPfXZJDq1YEz0qls1M=
X-Google-Smtp-Source: ABdhPJyvft7WsYNUaSZXozMezlBNTikxd4IfSiOUL3YIH/Ap43ggSX5uP4hR1ScdlCmofouhlQEW2zIdNa5uybXuMsw=
X-Received: by 2002:a92:dc81:: with SMTP id c1mr20059463iln.220.1600334193140;
 Thu, 17 Sep 2020 02:16:33 -0700 (PDT)
MIME-Version: 1.0
References: <202009170513.sIUVS6IQ%lkp@intel.com>
In-Reply-To: <202009170513.sIUVS6IQ%lkp@intel.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 17 Sep 2020 11:16:22 +0200
Message-ID: <CAOi1vP8RYp-wngs2JeuHxcwbeFkRApD3YVGuQN-dN95AZN5U6Q@mail.gmail.com>
Subject: Re: [ceph-client:testing 2/3] net/ceph/mon_client.c:928:2: warning:
 function 'do_mon_command_vargs' might be a candidate for 'gnu_printf' format attribute
To:     kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Sep 16, 2020 at 11:11 PM kernel test robot <lkp@intel.com> wrote:
>
> tree:   https://github.com/ceph/ceph-client.git testing
> head:   a274f50dee76e2182580cafeb908d95bda2cac70
> commit: c3e9a9f0a4b9178a5c4068b73d6579e8346cd3f3 [2/3] libceph: switch to the new "osd blocklist add" command
> config: arm-randconfig-r012-20200916 (attached as .config)
> compiler: arm-linux-gnueabi-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout c3e9a9f0a4b9178a5c4068b73d6579e8346cd3f3
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=arm
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>    net/ceph/mon_client.c: In function 'do_mon_command_vargs':
> >> net/ceph/mon_client.c:928:2: warning: function 'do_mon_command_vargs' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
>      928 |  len = vsprintf(h->str, fmt, ap);
>          |  ^~~
>
> # https://github.com/ceph/ceph-client/commit/c3e9a9f0a4b9178a5c4068b73d6579e8346cd3f3
> git remote add ceph-client https://github.com/ceph/ceph-client.git
> git fetch --no-tags ceph-client testing
> git checkout c3e9a9f0a4b9178a5c4068b73d6579e8346cd3f3
> vim +928 net/ceph/mon_client.c
>
>    898
>    899  static int do_mon_command_vargs(struct ceph_mon_client *monc,
>    900                                  const char *fmt, va_list ap)
>    901  {
>    902          struct ceph_mon_generic_request *req;
>    903          struct ceph_mon_command *h;
>    904          int ret = -ENOMEM;
>    905          int len;
>    906
>    907          req = alloc_generic_request(monc, GFP_NOIO);
>    908          if (!req)
>    909                  goto out;
>    910
>    911          req->request = ceph_msg_new(CEPH_MSG_MON_COMMAND, 256, GFP_NOIO, true);
>    912          if (!req->request)
>    913                  goto out;
>    914
>    915          req->reply = ceph_msg_new(CEPH_MSG_MON_COMMAND_ACK, 512, GFP_NOIO,
>    916                                    true);
>    917          if (!req->reply)
>    918                  goto out;
>    919
>    920          mutex_lock(&monc->mutex);
>    921          register_generic_request(req);
>    922          h = req->request->front.iov_base;
>    923          h->monhdr.have_version = 0;
>    924          h->monhdr.session_mon = cpu_to_le16(-1);
>    925          h->monhdr.session_mon_tid = 0;
>    926          h->fsid = monc->monmap->fsid;
>    927          h->num_strs = cpu_to_le32(1);
>  > 928          len = vsprintf(h->str, fmt, ap);
>    929          h->str_len = cpu_to_le32(len);
>    930          send_generic_request(monc, req);
>    931          mutex_unlock(&monc->mutex);
>    932
>    933          ret = wait_generic_request(req);
>    934  out:
>    935          put_generic_request(req);
>    936          return ret;
>    937  }
>    938
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

Yup, missed that.  Now fixed.

Thanks,

                Ilya
