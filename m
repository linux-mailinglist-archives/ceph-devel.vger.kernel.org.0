Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E54C17027B
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Feb 2020 16:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbgBZPbQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Feb 2020 10:31:16 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:37487 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728014AbgBZPbQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Feb 2020 10:31:16 -0500
Received: by mail-io1-f66.google.com with SMTP id c17so3783526ioc.4
        for <ceph-devel@vger.kernel.org>; Wed, 26 Feb 2020 07:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M9l6Nfhb+oyzyt1LbjCI9cxyu/WNpC0auGnM4s3jRao=;
        b=a0ozEjWr4jzUCW6RlAHIOPNpzClBjH+eqlp7pM9DKoHrorgBV4/QIk+Gcxp9sS6OVY
         SelrxyjO65sZTSDIbNWX2MExoKY6bDJZEOPfM98v2PQsNm62OJccf1MjcAVL9+9fg4ro
         qk0XE7kjZXhgj+VNFxk4lG7HvVpzhcf4mPbRpcLC1MrFprqcUzVlttbmHl5kYF62Q9j6
         NblF4jPByEY7j8FsEV0VIZ3oXHwxndvI5LwBQH7KruUNIBOyFP/N0S25y/3lAwXf6+Ot
         DmBWVKcImN0eO3emQ1N8Vzh2qqGOmddKQsxwS8Q/taXGlyZ2NwQ627q260D9SeDhfofF
         4Zrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M9l6Nfhb+oyzyt1LbjCI9cxyu/WNpC0auGnM4s3jRao=;
        b=B7RVMlTQRFUUVCDAxiafGGwkPrIfPQDjD+7AiNBZTMJqn1PFol00BC0N+B4eaEW+z1
         tNSSG9tyIQO1mbzP2MJXzZ8J1nRyxxFFXHLB6ucYU1OGZ8Q2jzV9t5sXTpQoHK4x8oo1
         jA+JGK2Zi6rh7nrqhsbyaqm0ezFt0XYSpo7vc1bif9PUA54kuA6ghrLM/cGrjAf2RW/O
         xdeYO3Y2L/5NX5hz2DDIZYKYaH/8G1/1x4PJg+22qZHUA+oJTaSK68kc0d1zx+54jlso
         JgfxOOSTQAzQA7e1R+YGgBruwKVwvQRAcP2sUgp8Dq9zEBGAodcrVNBsbZz/VKSooSVF
         Z/qQ==
X-Gm-Message-State: APjAAAVxLRsqa/XNBmIYeLKOUHpbNmo7nBjhvAEl8PeSqSLwP5dBZV3K
        JV1H6WLjdC/RQ9f6zNV1pWicC6gEumiA+3//OFc=
X-Google-Smtp-Source: APXvYqzJSahsfV6ciYooA5mIB+HyOHzHiGIbVrchEZKmASmR4zQGiOj+kfKY7W/xkgc3en2bHgzJekbld/tKFwjkUKE=
X-Received: by 2002:a6b:17c4:: with SMTP id 187mr4982116iox.143.1582731075666;
 Wed, 26 Feb 2020 07:31:15 -0800 (PST)
MIME-Version: 1.0
References: <20200226145927.jtuc5bgiojhoefad@kili.mountain>
In-Reply-To: <20200226145927.jtuc5bgiojhoefad@kili.mountain>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 26 Feb 2020 16:31:07 +0100
Message-ID: <CAOi1vP-gSGMQRPpPTJYAAYCLH2c=R0oGqmTrHeUjBt-oFL_c1g@mail.gmail.com>
Subject: Re: [bug report] libceph: revamp subs code, switch to SUBSCRIBE2 protocol
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Feb 26, 2020 at 3:59 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> Hello Ilya Dryomov,
>
> The patch 82dcabad750a: "libceph: revamp subs code, switch to
> SUBSCRIBE2 protocol" from Jan 19, 2016, leads to the following static
> checker warning:
>
>         net/ceph/mon_client.c:495 ceph_monc_handle_map()
>         error: dereferencing freed memory 'monc->monmap'
>
> net/ceph/mon_client.c
>    466  static void ceph_monc_handle_map(struct ceph_mon_client *monc,
>    467                                   struct ceph_msg *msg)
>    468  {
>    469          struct ceph_client *client = monc->client;
>    470          struct ceph_monmap *monmap = NULL, *old = monc->monmap;
>                                                     ^^^^^^^^^^^^^^^^^^
>
>    471          void *p, *end;
>    472
>    473          mutex_lock(&monc->mutex);
>    474
>    475          dout("handle_monmap\n");
>    476          p = msg->front.iov_base;
>    477          end = p + msg->front.iov_len;
>    478
>    479          monmap = ceph_monmap_decode(p, end);
>    480          if (IS_ERR(monmap)) {
>    481                  pr_err("problem decoding monmap, %d\n",
>    482                         (int)PTR_ERR(monmap));
>    483                  ceph_msg_dump(msg);
>    484                  goto out;
>    485          }
>    486
>    487          if (ceph_check_fsid(monc->client, &monmap->fsid) < 0) {
>    488                  kfree(monmap);
>    489                  goto out;
>    490          }
>    491
>    492          client->monc.monmap = monmap;
>    493          kfree(old);
>                       ^^^
> Frees monc->monmap.

Hi Dan,

There is no bug here, see https://lists.openwall.net/netdev/2018/11/27/81.

I'll simplify this code and CC you on a patch.

Thanks,

                Ilya
