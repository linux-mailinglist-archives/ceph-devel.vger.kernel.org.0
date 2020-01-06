Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15B6013143D
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Jan 2020 15:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgAFO7i (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jan 2020 09:59:38 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:44568 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgAFO7h (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Jan 2020 09:59:37 -0500
Received: by mail-il1-f194.google.com with SMTP id z12so6322256iln.11;
        Mon, 06 Jan 2020 06:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S/jebwPOZOQht3usJfKEu3FgzxbDletvVl/Mn3ZSls8=;
        b=Q4/OzEe+kjmfTUoh5hd/7fq1RzIJaqnmzUnDWeWlC2IVq6fc5j6Ij9J5tJ4Bfwnqak
         Kz/c7ASuRo9Pb9uzII6lCVjDvDD1V8EZ59tvAbQWLagoZgl+4jAu6T/lC0F5Bi/vqJtg
         Hi0Sgqr9h4GDtyJN9InzycN8AK+XX4LhpMEwlZqMSYcFep0wZutiq2bnuqVFYo5AJMwm
         +FfpkOhgF6f8LTuYjmMseTsSDHuz8d6dL8yytPJfNKNkUifK2AEMz+JMS944S70yLEh+
         w6xp8OkF0BJiaWs0AdbIfhUzixk0rYsI7U/fEq0flD3YbM5Wf8Q3xbADIxecwfFnRn7y
         +tXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S/jebwPOZOQht3usJfKEu3FgzxbDletvVl/Mn3ZSls8=;
        b=c5AEoOfXr4FWwvQSfTl7+UFdeyT+mUg1oXZQSerUUXf28BTifufqJe/3LfvI6J7he4
         QRCBXq+JlJ9Yt2IoxDf1Igqs0X4TPQgKGoSRVjkkt9tBLLLgpb8XeygOb3junnqEzT1X
         aed9mMfr1veBwnaaA5XqtR7yGwfzhLZP0efCPJ16xElZlIOqgY9tAmCnzx7nE3bG8WoK
         5lfk/RTd6407tGQ3w8iEB+03UIsfx1S8CgeXVnXtAMH5OvsEPA5xAtCWyk3NCUEaQ4zj
         tOb7hvFFX3J08rlhmvpeGdrWkTdZ8eie6FilP0xfaZ3ZNMfcDDCUE2vy2SDyFEdkFP+u
         m4Yw==
X-Gm-Message-State: APjAAAW3vc1L2VmjL443gK3YI2E4iRa4478Lyhk0XHuNYRyHL+D7Cjz2
        QfsWSFf/ket42Fza1Vv2NbFpYnXtzzKBgpZfguk=
X-Google-Smtp-Source: APXvYqy4u/JRres2EGU5ieqrujzsZ3D2NuFMJ0n4GDkilQZGf8717lzAiCYPxnnzuD9NYYD1NUX58LG4TQDZ3K45/6s=
X-Received: by 2002:a92:d7c6:: with SMTP id g6mr82995357ilq.282.1578322777185;
 Mon, 06 Jan 2020 06:59:37 -0800 (PST)
MIME-Version: 1.0
References: <1577111958-100981-1-git-send-email-chenwandun@huawei.com>
In-Reply-To: <1577111958-100981-1-git-send-email-chenwandun@huawei.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 6 Jan 2020 16:04:36 +0100
Message-ID: <CAOi1vP9-s9rp1=BTHrd=ounkZ0bzYV4HfKao6_GL+r8gh1muhg@mail.gmail.com>
Subject: Re: [PATCH next] ceph: Fix debugfs_simple_attr.cocci warnings
To:     Chen Wandun <chenwandun@huawei.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Dec 23, 2019 at 3:32 PM Chen Wandun <chenwandun@huawei.com> wrote:
>
> Use DEFINE_DEBUGFS_ATTRIBUTE rather than DEFINE_SIMPLE_ATTRIBUTE
> for debugfs files.
>
> Semantic patch information:
> Rationale: DEFINE_SIMPLE_ATTRIBUTE + debugfs_create_file()
> imposes some significant overhead as compared to
> DEFINE_DEBUGFS_ATTRIBUTE + debugfs_create_file_unsafe().
>
> Signed-off-by: Chen Wandun <chenwandun@huawei.com>
> ---
>  fs/ceph/debugfs.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index c281f32..60a0f1a 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -243,8 +243,8 @@ static int congestion_kb_get(void *data, u64 *val)
>         return 0;
>  }
>
> -DEFINE_SIMPLE_ATTRIBUTE(congestion_kb_fops, congestion_kb_get,
> -                       congestion_kb_set, "%llu\n");
> +DEFINE_DEBUGFS_ATTRIBUTE(congestion_kb_fops, congestion_kb_get,
> +                        congestion_kb_set, "%llu\n");
>
>
>  void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
> @@ -264,11 +264,11 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
>
>         dout("ceph_fs_debugfs_init\n");
>         fsc->debugfs_congestion_kb =
> -               debugfs_create_file("writeback_congestion_kb",
> -                                   0600,
> -                                   fsc->client->debugfs_dir,
> -                                   fsc,
> -                                   &congestion_kb_fops);
> +               debugfs_create_file_unsafe("writeback_congestion_kb",
> +                                          0600,
> +                                          fsc->client->debugfs_dir,
> +                                          fsc,
> +                                          &congestion_kb_fops);

Hi Chen,

debugfs_create_file_unsafe() has "unsafe" in its name for a reason.
Have you verified that this conversion is safe?

Thanks,

                Ilya
