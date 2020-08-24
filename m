Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460F3250151
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Aug 2020 17:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgHXPnR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Aug 2020 11:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727877AbgHXPj1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 24 Aug 2020 11:39:27 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5727AC06179B
        for <ceph-devel@vger.kernel.org>; Mon, 24 Aug 2020 08:38:28 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id 4so9069231ion.13
        for <ceph-devel@vger.kernel.org>; Mon, 24 Aug 2020 08:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z2cXui5sLPVtsgGcMeiqhcOrLps5U3uptMovPoBrkGk=;
        b=PPnkCom70dnP/Z2iRETBknO8U67tENKwtJCtukIYlYir9NONvPFxV6SeD8Goke62eC
         uGjoit5XKJCPjES10v6hmvayPof7cK9ACQZnggI9YdBD5TkU7ojzPDvfy8oKJ2p8k7XH
         kzVvWa5OdilMrq+gcVhUa7nGNES66SGXoacaEvTvjhJr33q03IYowGKUwPZ/mae7Ao7J
         jxK4jeSvixDoRPx3BYnamp4KyQK52qimbtwkwOjmNgDZxInyfQ0La3DHdczlSTRjxxQr
         l6MKBcGuOUTZBAZCB9zHhOvWwHNVTOw4qM/oHtNrOMYz3hwPsZrKoKrQGIAtDIfj0bsw
         wYpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z2cXui5sLPVtsgGcMeiqhcOrLps5U3uptMovPoBrkGk=;
        b=KTLNflJwlqLDjfbq6g8Px3DFxs8g/FDHbfknuxyj2xrn+Bhp91Iv3PBKRiFKQmN3dv
         biP+TZesOYPPV667IEY1x+KX/bWkPnh/nF1lA5vScT72wnSDz2FoDe4bmGxZmI6fHPZ0
         P+i4ckDcGcmfR8AWQQKH9h1o6hLvZLl4LevAKkZhsMzmDMVtxcV011/8XBiLz1SeDBdC
         G8WWyl+dXJYH7WLq2xxalQqQzmfhPMkSLa025uKeS9vbl9RlS/UstPsyWRhe4IUTIWM3
         5XZmrypn8Okz8RZcn3mMVv8zoYcA8aF5owsUW+dM+5eQ+bALNehqOLB9RzJPArs2UVhk
         OaEg==
X-Gm-Message-State: AOAM533ZjghI3GolRr3dkWENQXbKcBMtCQ5U6JMYe7y49vf3mgR134SQ
        smLVRG2YemuUc1DJ1w3A0jDsN7f/mWzAweFaPKQRnWWO4hQW7A==
X-Google-Smtp-Source: ABdhPJzfMP9MIzRaWY8xboCk2nubZXg87hdPJIHnA7r/02wKwZ7BQzhp3yr1n8SW8mq5vTofivIypxm3K9Kej/JiuEI=
X-Received: by 2002:a6b:bb43:: with SMTP id l64mr5342816iof.191.1598283507782;
 Mon, 24 Aug 2020 08:38:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200820151349.60203-1-jlayton@kernel.org>
In-Reply-To: <20200820151349.60203-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 24 Aug 2020 17:38:16 +0200
Message-ID: <CAOi1vP_i67NVgb_sef1ZS0K_ZHP5J_H=Op+LGs3n5CJbhR_95w@mail.gmail.com>
Subject: Re: [PATCH] ceph: don't allow setlease on cephfs
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Aug 20, 2020 at 5:13 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Leases don't currently work correctly on kcephfs, as they are not broken
> when caps are revoked. They could eventually be implemented similarly to
> how we did them in libcephfs, but for now don't allow them.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/dir.c  | 2 ++
>  fs/ceph/file.c | 1 +
>  2 files changed, 3 insertions(+)
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 040eaad9d063..34f669220a8b 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -1935,6 +1935,7 @@ const struct file_operations ceph_dir_fops = {
>         .compat_ioctl = compat_ptr_ioctl,
>         .fsync = ceph_fsync,
>         .lock = ceph_lock,
> +       .setlease = simple_nosetlease,
>         .flock = ceph_flock,
>  };
>
> @@ -1943,6 +1944,7 @@ const struct file_operations ceph_snapdir_fops = {
>         .llseek = ceph_dir_llseek,
>         .open = ceph_open,
>         .release = ceph_release,
> +       .setlease = simple_nosetlease,

Hi Jeff,

Isn't this redundant for directories?

Thanks,

                Ilya
