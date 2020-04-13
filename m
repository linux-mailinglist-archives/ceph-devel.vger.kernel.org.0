Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF99D1A6416
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Apr 2020 10:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgDMILX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Apr 2020 04:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:40974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729269AbgDMILC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 13 Apr 2020 04:11:02 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1339AC0085F3
        for <ceph-devel@vger.kernel.org>; Mon, 13 Apr 2020 01:09:13 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id w1so8562209iot.7
        for <ceph-devel@vger.kernel.org>; Mon, 13 Apr 2020 01:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3XWdPWy8WED6Ean+92O8Fs74YoMc4jecc/K5VwNmKtI=;
        b=dbjq+g1JnIxgE7fVxgwGoWPXfSu2vg5QtEGtNLQc6LXutM5aVBccYU1OBKM+echEnP
         WIDRS3IauwgKySfOcp96Mlz12rKv6qKu4RNwTNrFl8wWm0thj/I7VFMOmDUghV/SNbyZ
         5gwMPpMXNW1BeVDxCbkY3Ams1RJfIvLc4H9222RvYodDeiPEKQZdmpMTeyJqhpFJw5HW
         Ynq5coVR2Qq3rDCEfwz1/Eys//142EN3d23wsG7rOn4uI47Nk9xLp4myLPwCxYlZgoyj
         sB31l9PG1oLzFbpLiK8Jts1yCkuWfH0NCa/bj0rNXdOg03EEzLthBEXuhrxO8gmjJ81S
         4qtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3XWdPWy8WED6Ean+92O8Fs74YoMc4jecc/K5VwNmKtI=;
        b=Kn2acGLh/qsjHAFunfxxWgR9zfuYKu5uesKZKeC+5LbYKnfwPGKqAKK1MEtinnYJMV
         8P4YW5WJvxNueXPDO4be2Zi8SB2lZSGhP2xdpfHLAvZ8PfHNDeb2hFDGe2HYnv3HYUQX
         ThTCdDVj3p8uokh/LB7UV/oF9L2f2K8T3HW1gzmPukRjqYmNNog2cWmFQ2zy8OELvcM1
         9hshiVYMyGhFPUZSGwi5C3W1yqKmRmlIr3VukXLBrVAHH0eFOwojVaacXalNui/Y20Bf
         DjvMR23xWH85eKBv6JiHoXt4ZcqDiEmcYRdmnhkrHkuCMyWywL02vsJhNelB5K403Ere
         4CVA==
X-Gm-Message-State: AGi0PuaHCwcIUGkl+MiH2km5Pe03JeVpaGMz57gUiwmozXAOHxSoMuBA
        dsTSJeLMKMVbY/xg11ieeh49qcEQZPfjnDpZo4E=
X-Google-Smtp-Source: APiQypIKIr4QaoNgy1uhs/Pt/OUr/2cGzFHZ0XAzRd14oIRyKNwjNJyCu615O40CmudK21lDvo//KJZlYQQD6Ye31lY=
X-Received: by 2002:a02:2a47:: with SMTP id w68mr14558166jaw.76.1586765352473;
 Mon, 13 Apr 2020 01:09:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200408142125.52908-1-jlayton@kernel.org> <20200408142125.52908-2-jlayton@kernel.org>
In-Reply-To: <20200408142125.52908-2-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 13 Apr 2020 10:09:05 +0200
Message-ID: <CAOi1vP99BbHFrrg+0HAbZrZV7DQ7EG7euTY6cbtdWajsdyN3jQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] ceph: have ceph_mdsc_free_path ignore ERR_PTR values
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sage Weil <sage@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Apr 8, 2020 at 4:21 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> This makes the error handling simpler in some callers, and fixes a
> couple of bugs in the new async dirops callback code.
>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/debugfs.c    | 4 ----
>  fs/ceph/mds_client.c | 6 ++----
>  fs/ceph/mds_client.h | 2 +-
>  3 files changed, 3 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index eebbce7c3b0c..3a198e40f100 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -83,8 +83,6 @@ static int mdsc_show(struct seq_file *s, void *p)
>                 } else if (req->r_dentry) {
>                         path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
>                                                     &pathbase, 0);
> -                       if (IS_ERR(path))
> -                               path = NULL;
>                         spin_lock(&req->r_dentry->d_lock);
>                         seq_printf(s, " #%llx/%pd (%s)",

Hi Jeff,

This ends up attempting to print an IS_ERR pointer as %s.

>                                    ceph_ino(d_inode(req->r_dentry->d_parent)),
> @@ -102,8 +100,6 @@ static int mdsc_show(struct seq_file *s, void *p)
>                 if (req->r_old_dentry) {
>                         path = ceph_mdsc_build_path(req->r_old_dentry, &pathlen,
>                                                     &pathbase, 0);
> -                       if (IS_ERR(path))
> -                               path = NULL;
>                         spin_lock(&req->r_old_dentry->d_lock);
>                         seq_printf(s, " #%llx/%pd (%s)",

Ditto.

It looks like in newer kernels printf copes with this and outputs
"(efault)".  But anything older than 5.2 will crash.

Further, the code looks weird because ceph_mdsc_build_path() doesn't
return NULL, but path is tested for NULL in the call to seq_printf().

Why not just follow the same approach as existing mdsc_show()?  It
makes it clear that the error is handled and where the NULL pointer
comes from.  This kind of "don't handle errors and rely on everything
else being able to bail" approach is very fragile and hard to audit.

Thanks,

                Ilya
