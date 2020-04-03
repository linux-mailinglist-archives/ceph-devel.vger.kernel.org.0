Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C43319CEDC
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Apr 2020 05:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390336AbgDCDW2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 Apr 2020 23:22:28 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:38538 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390222AbgDCDW2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 2 Apr 2020 23:22:28 -0400
Received: by mail-qv1-f67.google.com with SMTP id p60so2957373qva.5
        for <ceph-devel@vger.kernel.org>; Thu, 02 Apr 2020 20:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WlvxnTU7z1T6FMc6sXLJOkE7GdisDG1djS1V8DzdvX8=;
        b=sFzhK4AMzau+MqFtt18DynzqseqmzIx8U2WhHjeMHDpPaiefqJAfTLP9EJyTHB056C
         wyvIyAhs55LL/X2GNL/csGhwteN+wrXeeKYxw4IC0MK1Mch/QQDkR9axPs17niBA11Vg
         0UtcejcDeYSUuRGU3w0F2qjd6bpKUf19qgAUZ+hHbadFSV7sbN9coQ6LW4tW6NsA7uNC
         n8tQW+T9ZB1tzsKLQUvJtUgArAL/fZnxOkdyCxYhQm0AL9MILHjmFVnOUOB0d+kOdf48
         ZZXkNbZmdvwVfX2BERa1VnaEraX2XhnvDc4LQny61jn1Q3KGE4kYqIzwFKwdELtHWtrv
         lMuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WlvxnTU7z1T6FMc6sXLJOkE7GdisDG1djS1V8DzdvX8=;
        b=WO8Kf20Q2knGp/AKc+38Iq1tlmV1tWidqS+BsnMAFXw5XJIyXs8sowjeKkG4N7npzq
         azTVcW92d+fKpJYKssEyKkJ1cX5OVqEd81g78u3FfQzD2YFY+JOvnSZuYBmUA0+xG/I6
         ZujAp40z3KkWn8MteoYaLYkv20uLAG1dPLJ9VzxMGrsm7i4wXpknIuEzoPxoGOg2RhZr
         BPU5oi7jM6zF5JgLEeOoejBQzz58UEqz33Nrt3CQOYIestUPO+FxzDRNqH57gHWZvUM2
         gU3CRVLO+q50LSBWuj3b49wWmENh6aqcQp/cc8sxrzc68wW84x0X3ZV+MAlI7OyoINx1
         JFsA==
X-Gm-Message-State: AGi0PuaIf3DlwDAJOK06KcnaY0cozAL1qvZDekQfaDKNpVTr2YSP6iVO
        SDPWhvLEUymhvHzNq0L/qulDSM9NNCMha1aynB8=
X-Google-Smtp-Source: APiQypIY76IfCmBELE6Rq62Wf3Yf3BHjEkG/8zuR6hru6h0CKRrkQoXQ22yfRuPal51NzaIKpTtMkweAxnvjfinu5jM=
X-Received: by 2002:ad4:4447:: with SMTP id l7mr6595594qvt.128.1585884145873;
 Thu, 02 Apr 2020 20:22:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200402112911.17023-1-jlayton@kernel.org> <20200402112911.17023-3-jlayton@kernel.org>
In-Reply-To: <20200402112911.17023-3-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Fri, 3 Apr 2020 11:22:14 +0800
Message-ID: <CAAM7YAndjpYH9qo3ELMrvMV8T5M5RTMB3DyeakiEAjsq3RwXQA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ceph: request expedited service on session's last
 cap flush
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        Jan Fajerski <jfajerski@suse.com>,
        Luis Henriques <lhenriques@suse.com>,
        Gregory Farnum <gfarnum@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Apr 2, 2020 at 7:29 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> When flushing a lot of caps to the MDS's at once (e.g. for syncfs),
> we can end up waiting a substantial amount of time for MDS replies, due
> to the fact that it may delay some of them so that it can batch them up
> together in a single journal transaction. This can lead to stalls when
> calling sync or syncfs.
>
> What we'd really like to do is request expedited service on the _last_
> cap we're flushing back to the server. If the CHECK_CAPS_FLUSH flag is
> set on the request and the current inode was the last one on the
> session->s_cap_dirty list, then mark the request with
> CEPH_CLIENT_CAPS_SYNC.
>
> Note that this heuristic is not perfect. New inodes can race onto the
> list after we've started flushing, but it does seem to fix some common
> use cases.
>
> Reported-by: Jan Fajerski <jfajerski@suse.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 95c9b25e45a6..3630f05993b3 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1987,6 +1987,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>         }
>
>         for (p = rb_first(&ci->i_caps); p; p = rb_next(p)) {
> +               int mflags = 0;
>                 struct cap_msg_args arg;
>
>                 cap = rb_entry(p, struct ceph_cap, ci_node);
> @@ -2118,6 +2119,9 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>                         flushing = ci->i_dirty_caps;
>                         flush_tid = __mark_caps_flushing(inode, session, false,
>                                                          &oldest_flush_tid);
> +                       if (flags & CHECK_CAPS_FLUSH &&
> +                           list_empty(&session->s_cap_dirty))
> +                               mflags |= CEPH_CLIENT_CAPS_SYNC;
>                 } else {
>                         flushing = 0;
>                         flush_tid = 0;
> @@ -2128,8 +2132,8 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>
>                 mds = cap->mds;  /* remember mds, so we don't repeat */
>
> -               __prep_cap(&arg, cap, CEPH_CAP_OP_UPDATE, 0, cap_used, want,
> -                          retain, flushing, flush_tid, oldest_flush_tid);
> +               __prep_cap(&arg, cap, CEPH_CAP_OP_UPDATE, mflags, cap_used,
> +                          want, retain, flushing, flush_tid, oldest_flush_tid);
>                 spin_unlock(&ci->i_ceph_lock);
>
>                 __send_cap(mdsc, &arg, ci);
> --
> 2.25.1
>
    Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
