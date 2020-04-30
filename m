Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039D61BF1E4
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Apr 2020 09:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgD3H4E (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Apr 2020 03:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgD3H4D (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 30 Apr 2020 03:56:03 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88342C035494;
        Thu, 30 Apr 2020 00:56:01 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id i16so2707501ybq.9;
        Thu, 30 Apr 2020 00:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=niS1lYC7PeJRfKiA0LkBJ0AjWmjRNXbULNT5s9yDbmg=;
        b=b0uFxMCcUOu+UKVq2cT5YgabZJAPo/fDcBjEXk+cSKEeRAG22tjX3jVOWO+ZroquVd
         W9bUt5rw6VnC0eEduCX0Zzs6W90YBy7LJ0rjVk+g+GcOpiAQnkXc69wVui4Gy+dulxQO
         H5Z5KXF4B6cpy8K7KhLSKDH0KYMcEcL+2NUrtH8JsbDCdfzgBMJML0K7OXfwPmA1FRKc
         VITGeiylsb2lDaavq7fbUtacVTtXdduADHsYgIyt7gfdAFHiUt8UfbRUyTtefrOXG8OE
         5uwsD+bm910DqlFmSchYMiarOTh/C0Ddrjqe9AqCfDgxbEjax5Oz2jDIxvhFfRAxHlQL
         8RRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=niS1lYC7PeJRfKiA0LkBJ0AjWmjRNXbULNT5s9yDbmg=;
        b=KpY9Iwzjm4nfkNaB0vhRvyHtGXqpEajpJTwU28T5hH0FsXETqoKiny7zX7Z4rJizsE
         NYnRPn4L37XLrrv7Gnl4UdcA/b/ZDruvcscM19swf5TQqKStc536BUBxkGIA8+spryGp
         QW9opBN+nRjT1F/JixzbQadIkTnxr/uivr2zzydWBSFseBFzL14JPskDMBXHB7AXZOop
         vt1xpKQ+6ruQbA+FR7PkrtzdqIMa2a6uZ52+qLown91EHCl795d22+agPg/ha27MX9Qf
         /Dr3WPLHkCelUhFNGOM0bxoFrV33jvCVetOxynv1OAwktg11XXQsZI3bbC0sMI59tSZ3
         20LA==
X-Gm-Message-State: AGi0PuaY1i7x181+jc87eaE9Cyd2iDvyJC/FRwhnAdalXEVHSGW3aH0/
        Ff9g8CnyepSjdmEw440vGjLpobYcO6Mwa/q11Yc=
X-Google-Smtp-Source: APiQypJW6Wl4fp6m3eGWIxmzUP0iVI32e5m23IE4bncxZ3oeAhUC4jfaQIKSfz7yzxcYIc7LPFYDXzjybUfztGgMj68=
X-Received: by 2002:a25:b8f:: with SMTP id 137mr3875233ybl.21.1588233360816;
 Thu, 30 Apr 2020 00:56:00 -0700 (PDT)
MIME-Version: 1.0
References: <1588227169-83237-1-git-send-email-wubo40@huawei.com>
In-Reply-To: <1588227169-83237-1-git-send-email-wubo40@huawei.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 30 Apr 2020 15:55:49 +0800
Message-ID: <CAAM7YA=BDutG7sOxHDYDcg141vsTRqQCr5pXOxqmOo9JdXjwsw@mail.gmail.com>
Subject: Re: [PATCH V3] fs/ceph:fix double unlock in handle_cap_export()
To:     Wu Bo <wubo40@huawei.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        liuzhiqiang26@huawei.com, linfeilong@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Apr 30, 2020 at 2:13 PM Wu Bo <wubo40@huawei.com> wrote:
>
> If the ceph_mdsc_open_export_target_session() return fails,
> we should add mutex_lock(&session->s_mutex) on IS_ERR(tsession) block
> to avoid twice unlocking. because the session->s_mutex will be unlock
> at the out_unlock lable.
>
> --
> v2 -> v3:
>   - Rewrite solution, adding a mutex_lock(&session->s_mutex)
>     to the IS_ERR(tsession) block.
>   - Modify the comment more clearly.
> v1 -> v2:
>   - add spin_lock(&ci->i_ceph_lock) before goto out_unlock lable
>
>
> Signed-off-by: Wu Bo <wubo40@huawei.com>
> ---
>  fs/ceph/caps.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 185db76..d27d778 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3746,6 +3746,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
>                 WARN_ON(1);
>                 tsession = NULL;
>                 target = -1;
> +               mutex_lock(&session->s_mutex);
>         }
>         goto retry;
>
> --
> 1.8.3.1
>

 Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
