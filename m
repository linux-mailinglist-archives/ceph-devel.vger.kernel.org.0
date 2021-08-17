Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CB33EEB33
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Aug 2021 12:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239677AbhHQKrz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Aug 2021 06:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235350AbhHQKry (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 17 Aug 2021 06:47:54 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A75FC061764
        for <ceph-devel@vger.kernel.org>; Tue, 17 Aug 2021 03:47:22 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id j18so11675760ioj.8
        for <ceph-devel@vger.kernel.org>; Tue, 17 Aug 2021 03:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1OKGDH4e8MqwAiHG0AwgvQ+zYm6xQaBcYWM3qEt1LQ4=;
        b=jdz2Db6UiVka50O6Gai2aM9s9mkcRgZDidd8gLFVHioFic+HGSGvg7xblMZoshlwYH
         bm1xELEm6HEf1wQ4fX8Sl9R3H/CjBfXTiXc/kaUo6dMMxkB2YFydDkkYP3XpOE1q60EO
         uqqsiJ0MOQr0r1c1e7LxJIyfXm+yOh+x73U4CXyUDOQ4T6NTOi+qLEnqreycxwsxMfqy
         hWB5v819f/pc3LGkbfZ6oztJWe4L1G6WXNeoxWh05+bk+K6S8fd+7aDya/vbdFn+faiJ
         BP/RSvJIJ62bGQgE4CCpXjmItcH1LSVKz7kddjNSk46RXzJPR10UXa4cip7NWs7AqYlP
         s84Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1OKGDH4e8MqwAiHG0AwgvQ+zYm6xQaBcYWM3qEt1LQ4=;
        b=MesclD3yqMAivTDUwADF7BYuC5YcugNdXbY3d8Fz1izla7prWr1VcWNslsG2szYclf
         r1NUQoP8bmEw1NMZb7l+N7DQ6AdAlaPOaXOSKUqXIskBalJcHOzaY2yIlLs6ST9QmDBF
         AGQFeVPHeL4Y0kbETeRxyNXEbbW8vvVjIQhGJaNfwLoipInLbpYkzggPTZ2G4b40TZsf
         Mj7J0r4ISGlMPkEW3SKAEjHRPnupCi8GINrHByh1zWRqa1Te+EEg8xjyWReV4WdtMl7/
         mMNQlmOr3+fVPVOe6NgrGIBbPEJ8hYHduspwJB+c45BAgYNC/qApj42qbWnaDbm5yG9i
         4oBQ==
X-Gm-Message-State: AOAM533HMK/7JFLQKpej1T+Z2AhD+jDY6HP/vJgMfDPF38JmGPqWIAEk
        vicyBD3wZlSOM1fF2zAd0qUM6+JjqXHwxx3nN/8=
X-Google-Smtp-Source: ABdhPJyJwWxut5DVgvZwD5uhFGqLsyeTBYYJLL/L64/NN/m/D35wyXKRh0Zxc7lK6QrPVk/7dR13XSL4YVqJiLLop6E=
X-Received: by 2002:a02:cca8:: with SMTP id t8mr2398748jap.51.1629197241688;
 Tue, 17 Aug 2021 03:47:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210817075816.190025-1-xiubli@redhat.com>
In-Reply-To: <20210817075816.190025-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 17 Aug 2021 12:46:21 +0200
Message-ID: <CAOi1vP_sO19Fpt=_4J9x-m_PSjP6oNsR2X9PvXZMTeqRsr5Twg@mail.gmail.com>
Subject: Re: [PATCH] ceph: correctly release memory from capsnap
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Aug 17, 2021 at 9:58 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> When force umounting, it will try to remove all the session caps.
> If there has any capsnap is in the flushing list, the remove session
> caps callback will try to release the capsnap->flush_cap memory to
> "ceph_cap_flush_cachep" slab cache, while which is allocated from
> kmalloc-256 slab cache.
>
> URL: https://tracker.ceph.com/issues/52283
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 00b3b0a0beb8..cb517753bb17 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -1264,10 +1264,18 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>         spin_unlock(&ci->i_ceph_lock);
>         while (!list_empty(&to_remove)) {
>                 struct ceph_cap_flush *cf;
> +               struct ceph_cap_snap *capsnap;

Hi Xiubo,

Add an empty line here.

>                 cf = list_first_entry(&to_remove,
>                                       struct ceph_cap_flush, i_list);
>                 list_del(&cf->i_list);
> -               ceph_free_cap_flush(cf);
> +               if (cf->caps) {
> +                       ceph_free_cap_flush(cf);
> +               } else if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {

What does this condition guard against?  Are there other cases of
ceph_cap_flush being embedded that need to be handled differently
on !SHUTDOWN?

Should capsnaps be on to_remove list in the first place?

This sounds like stable material to me.

Thanks,

                Ilya
