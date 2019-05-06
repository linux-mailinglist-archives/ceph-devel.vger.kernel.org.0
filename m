Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D86514860
	for <lists+ceph-devel@lfdr.de>; Mon,  6 May 2019 12:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbfEFKde (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 May 2019 06:33:34 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:36028 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfEFKde (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 May 2019 06:33:34 -0400
Received: by mail-it1-f194.google.com with SMTP id o190so1968768itc.1
        for <ceph-devel@vger.kernel.org>; Mon, 06 May 2019 03:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hokVy2QgUajKABvnoJdoBS0jvEPhq14AD/Ck/Mjt5cs=;
        b=XuKqyR44AjQVPxoDwXkEMk90jA+2LJhYohKccls5qWA8o2oJT1oLz1no7KJ41JS/wX
         jTEINJYr31eVR0wtTlK6MTRZ4snRw7orXmcZASel2K4hidEWeux1dK4FNbP8Z8jZ5wg7
         RR60/wgWOaAsNuLerzOqgXf2r+zGqHqm1WICVX16S8UyTnFSdcZ97lz7EU7SV2dqlZIg
         lawnWpaNoT69O3J+yY60jM852wsyd4pvatTnGQ/Dusy2+SnTllNKPiwYhWmWu7HLiTMZ
         24bcoqWFsVpTnYMOc/XvkvMQTR4hHRLgs3FkQ7Ltrp/dAIJv1nCuAID9ZjFVEjAj/Ao4
         +dGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hokVy2QgUajKABvnoJdoBS0jvEPhq14AD/Ck/Mjt5cs=;
        b=B96MbIJED6CbNEdPBKBYzgvcL9nVKdX553/KPgdwsEnlrJTK2q3FfCNNfS0kYiXGaW
         wEsqHlxEAJfa9oHgrSdTxQt+LaCvkdw0JONnUq5GgBuAM9ZcQtKDW9LHwBxHAbCYcJ4U
         k8nQUpJnThhL1gG03KvJ43XwaSKxk5omCR4xde79DVoGQvQimZVRX0WjlsRigLNPs9pv
         bV4VgGkCTuza7Qz49WDjU8o+O2LFdx6REUXi/t/DXGjnAznswj4OtYK0CmzMKq7fFnCT
         8BlzzbXU+WXT3sitTUasaGpNsmDzQQfbVMPXpa7JhKmojMFf7wa3AgndzXovlx6tYJNN
         f0zw==
X-Gm-Message-State: APjAAAVdw+66mla0sma05GawMRsXXedEDOjw4cb/SGGr+vv4LHPobCZx
        pdx3n1CjyG5aYxKr0uun25O8dmK4/eekSWjmc28=
X-Google-Smtp-Source: APXvYqz3GNfw+tDGELll+V0/Wx9Lo4cQV5Q8kgxW4XHhK81FH9k5A6BI61Z7XOiJBQshMQoNPIpD0CJ2xQctbeMUpa0=
X-Received: by 2002:a02:a394:: with SMTP id y20mr17879813jak.96.1557138813383;
 Mon, 06 May 2019 03:33:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190502184638.3614-1-jlayton@kernel.org> <20190502184638.3614-2-jlayton@kernel.org>
In-Reply-To: <20190502184638.3614-2-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 6 May 2019 12:33:40 +0200
Message-ID: <CAOi1vP-z6zqnQuef1t2h7EjsCsyYjL8-Nb-EG8CZU1WMqTY-NA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] libceph: make ceph_pr_addr take an struct
 ceph_entity_addr pointer
To:     Jeff Layton <jlayton@kernel.org>
Cc:     "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, May 2, 2019 at 8:46 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> GCC9 is throwing a lot of warnings about unaligned accesses by
> callers of ceph_pr_addr. All of the current callers are passing a
> pointer to the sockaddr inside struct ceph_entity_addr.
>
> Rename the existing function to ceph_pr_sockaddr, and add a new
> ceph_pr_addr that takes an ceph_entity_addr instead. We can then
> have it make a copy of the sockaddr before printing.

Looks like a leftover from v1?

>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/debugfs.c              |  2 +-
>  fs/ceph/mdsmap.c               |  2 +-
>  include/linux/ceph/messenger.h |  3 ++-
>  net/ceph/cls_lock_client.c     |  2 +-
>  net/ceph/debugfs.c             |  4 +--
>  net/ceph/messenger.c           | 48 +++++++++++++++++-----------------
>  net/ceph/mon_client.c          |  6 ++---
>  net/ceph/osd_client.c          |  2 +-
>  8 files changed, 35 insertions(+), 34 deletions(-)
>
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index b014fc7d4e3c..b3fc5fe26a1a 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -37,7 +37,7 @@ static int mdsmap_show(struct seq_file *s, void *p)
>                 struct ceph_entity_addr *addr = &mdsmap->m_info[i].addr;
>                 int state = mdsmap->m_info[i].state;
>                 seq_printf(s, "\tmds%d\t%s\t(%s)\n", i,
> -                              ceph_pr_addr(&addr->in_addr),
> +                              ceph_pr_addr(addr),
>                                ceph_mds_state_name(state));
>         }
>         return 0;
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index 977cacd3825f..45a815c7975e 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -205,7 +205,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>
>                 dout("mdsmap_decode %d/%d %lld mds%d.%d %s %s\n",
>                      i+1, n, global_id, mds, inc,
> -                    ceph_pr_addr(&addr.in_addr),
> +                    ceph_pr_addr(&addr),
>                      ceph_mds_state_name(state));
>
>                 if (mds < 0 || state <= 0)
> diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
> index 800a2128d411..23895d178149 100644
> --- a/include/linux/ceph/messenger.h
> +++ b/include/linux/ceph/messenger.h
> @@ -323,7 +323,8 @@ struct ceph_connection {
>  };
>
>
> -extern const char *ceph_pr_addr(const struct sockaddr_storage *ss);
> +extern const char *ceph_pr_addr(const struct ceph_entity_addr *addr);
> +
>  extern int ceph_parse_ips(const char *c, const char *end,
>                           struct ceph_entity_addr *addr,
>                           int max_count, int *count);
> diff --git a/net/ceph/cls_lock_client.c b/net/ceph/cls_lock_client.c
> index 2105a6eaa66c..4cc28541281b 100644
> --- a/net/ceph/cls_lock_client.c
> +++ b/net/ceph/cls_lock_client.c
> @@ -271,7 +271,7 @@ static int decode_locker(void **p, void *end, struct ceph_locker *locker)
>
>         dout("%s %s%llu cookie %s addr %s\n", __func__,
>              ENTITY_NAME(locker->id.name), locker->id.cookie,
> -            ceph_pr_addr(&locker->info.addr.in_addr));
> +            ceph_pr_addr(&locker->info.addr));
>         return 0;
>  }
>
> diff --git a/net/ceph/debugfs.c b/net/ceph/debugfs.c
> index 46f65709a6ff..63aef9915f75 100644
> --- a/net/ceph/debugfs.c
> +++ b/net/ceph/debugfs.c
> @@ -46,7 +46,7 @@ static int monmap_show(struct seq_file *s, void *p)
>
>                 seq_printf(s, "\t%s%lld\t%s\n",
>                            ENTITY_NAME(inst->name),
> -                          ceph_pr_addr(&inst->addr.in_addr));
> +                          ceph_pr_addr(&inst->addr));
>         }
>         return 0;
>  }
> @@ -82,7 +82,7 @@ static int osdmap_show(struct seq_file *s, void *p)
>                 char sb[64];
>
>                 seq_printf(s, "osd%d\t%s\t%3d%%\t(%s)\t%3d%%\n",
> -                          i, ceph_pr_addr(&addr->in_addr),
> +                          i, ceph_pr_addr(addr),
>                            ((map->osd_weight[i]*100) >> 16),
>                            ceph_osdmap_state_str(sb, sizeof(sb), state),
>                            ((ceph_get_primary_affinity(map, i)*100) >> 16));
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index 54713836cac3..a4432c220d02 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -186,17 +186,18 @@ static atomic_t addr_str_seq = ATOMIC_INIT(0);
>
>  static struct page *zero_page;         /* used in certain error cases */
>
> -const char *ceph_pr_addr(const struct sockaddr_storage *ss)
> +const char *ceph_pr_addr(const struct ceph_entity_addr *addr)
>  {
>         int i;
>         char *s;
> -       struct sockaddr_in *in4 = (struct sockaddr_in *) ss;
> -       struct sockaddr_in6 *in6 = (struct sockaddr_in6 *) ss;
> +       const struct sockaddr_storage ss = addr->in_addr;

Is this const really needed?  I'd add a comment here, same as in
previous patch.

Thanks,

                Ilya
