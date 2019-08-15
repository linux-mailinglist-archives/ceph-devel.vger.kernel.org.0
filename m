Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80DA28EBF3
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Aug 2019 14:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731638AbfHOMvu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 15 Aug 2019 08:51:50 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40629 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729627AbfHOMvt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 15 Aug 2019 08:51:49 -0400
Received: by mail-qt1-f193.google.com with SMTP id e8so2155416qtp.7
        for <ceph-devel@vger.kernel.org>; Thu, 15 Aug 2019 05:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vDxpi3VtyQtbGKAXa10ENJoIPaDUdxpEr2EhOT9Nysg=;
        b=KtOlwrc9lmJGyW+RpeeyoqgJeLIkZwZqd0t0IVenBC/fKxZYe+u5TBTCgEe7S7CNGi
         WVmTw4FgA0WJLPPNhWjEidXWplgA9LniABl4kzCZSkX6Nnx3zbm/k1OMNtEmTDalVDoL
         MQKiflzcv4lm97dQwBBrjdR2jHNHpEaysU7gXxpn4hb7wPRXKOwNRCm2aky12E7i394O
         LNh2js8M42PCylZIQY6rrmdCdWf6zcDQ8mdFDgMtFPMpK27+TEGWB67uFuV+5jpdh5rn
         k8d5u8Zz/qJVXRyEJecT9sb7dvfAcdSaJnQt+4T/lsiMSZOypRKyybRAOoNlc1DM8BnM
         u4KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vDxpi3VtyQtbGKAXa10ENJoIPaDUdxpEr2EhOT9Nysg=;
        b=briBI6cPscQIoMNvAWSmNTh6sVkblN/6Dl9MfnZOfdnQeQ3J9lNCuuIJC9u+nYX/cQ
         Gu0VCam/II3qZ/HGu7oJ4u3yy97nR4o8fOstJdoT7slRufqX62JPUe6h4odk/7AnJZBC
         JV1+IrIkvlFWWZFoqmgyWxszXuXJutfsoM96ur2PFL5TjIZB9zM9+xSZC22igklHOtoL
         IGC5yvrqMghxmPxUxsOPgV7ldMca9xZ5GvW3wkvk/X+sojBX3gLTBgw4GryJ52tyhbJe
         wubqUR23TdfxywTbVhBnidGTgJIOacPQLmKC25X6KZAO/agGxhoMA2YYmLzFyfmY2ujB
         kHFA==
X-Gm-Message-State: APjAAAUVM2/KkidEudPcWq7jlQykmIDoMZY/5tXge8a6EQDbuXWB8svj
        rXycLusisrx3qJB5KiMofIofjPXy7mzoXCn+HL4=
X-Google-Smtp-Source: APXvYqz2Gu9a9FOMcTdTe54ylOdtBUzI6tqx9yveGgMAS1a0o4yqQwtoJtC9V5Gr+vs54yjOF+lK/Q3R7sj3onW0Dqc=
X-Received: by 2002:ac8:4103:: with SMTP id q3mr3693791qtl.296.1565873508856;
 Thu, 15 Aug 2019 05:51:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190815121555.15825-1-jlayton@kernel.org>
In-Reply-To: <20190815121555.15825-1-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 15 Aug 2019 20:51:37 +0800
Message-ID: <CAAM7YA=yJmLpgNRL4SGYG65TbJ9oYt2LdHxbcjYN6U-Ce1T4fw@mail.gmail.com>
Subject: Re: [PATCH] ceph: don't try fill file_lock on unsuccessful
 GETFILELOCK reply
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Hector Martin <hector@marcansoft.com>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Aug 15, 2019 at 8:15 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> When ceph_mdsc_do_request returns an error, we can't assume that the
> filelock_reply pointer will be set. Only try to fetch fields out of
> the r_reply_info when it returns success.
>
> Cc: stable@vger.kernel.org
> Reported-by: Hector Martin <hector@marcansoft.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/locks.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
> index cb216501c959..544e9e85b120 100644
> --- a/fs/ceph/locks.c
> +++ b/fs/ceph/locks.c
> @@ -115,8 +115,7 @@ static int ceph_lock_message(u8 lock_type, u16 operation, struct inode *inode,
>                 req->r_wait_for_completion = ceph_lock_wait_for_completion;
>
>         err = ceph_mdsc_do_request(mdsc, inode, req);
> -
> -       if (operation == CEPH_MDS_OP_GETFILELOCK) {
> +       if (!err && operation == CEPH_MDS_OP_GETFILELOCK) {
>                 fl->fl_pid = -le64_to_cpu(req->r_reply_info.filelock_reply->pid);
>                 if (CEPH_LOCK_SHARED == req->r_reply_info.filelock_reply->type)
>                         fl->fl_type = F_RDLCK;
> --
> 2.21.0
>

Reviewed by
