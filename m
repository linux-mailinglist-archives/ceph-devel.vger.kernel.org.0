Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E798A037C
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Aug 2019 15:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfH1NjQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 28 Aug 2019 09:39:16 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45821 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbfH1NjL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 28 Aug 2019 09:39:11 -0400
Received: by mail-qk1-f194.google.com with SMTP id m2so2360418qki.12
        for <ceph-devel@vger.kernel.org>; Wed, 28 Aug 2019 06:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h1Ngiab+iFmmsb3RWkFP+J8o7sQIK8V0whXnozJzv+0=;
        b=gVJx+CEoPdzNphYWDD8JA7ZJWVKRarpJWtBkLDGSZJSPahe9TymxODNtfR0xzodbig
         bbWfFnzhRDXAlCo1OQZU3XAXy8Wlv4wETGFKP/o1hBFSq7MSKX5XZ4N2aVVxb6xe7pQ7
         Q7bWLj1t/PVx2MkjhJf807Bzq4SOVqEu/H/3+ICDuEY2lFyQPRUcBfL056O8dRR3/xxs
         Cyz7+gPmPB6qoeJspJRgHZ+i+yLIQK5hio8aeNvg2y+pBq/Ed99VmZ6cWcLYrlvnDTVi
         RSBhhyE0m7wW/WEZ2I/abe6mG3+9Bax678PFm6S9JB8U1aowiywCZi5CzPhuKKUKbS0K
         qpHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h1Ngiab+iFmmsb3RWkFP+J8o7sQIK8V0whXnozJzv+0=;
        b=dFd/BIhQJKXPUvIZtmWkncAq88Z6tveFgpyvCzv/ZvFAQrpC4pQZ5TC5Tn/SNa9yRQ
         jkdBpgNJ7qT8r6bGp0E4wHsbe38aiLqh81iOoxuDF9lrTWr4xOQylK+e6Q99nI5meccm
         7XvA4yemE++GFIZtSn1YYTqMHlZBigeHOF593X4Js506X/lmTRXaWnTrSKBYphBl3gvC
         LCsLMVjdybJ9yPmBsAVTbw34x7W6XdM4+SYG5tdDhk9qM43WuW9XoGkjLvGricM8wz+9
         jxd4XE/jAYNVgJ6cqBNw0XscVvqdGxAbZRGrB6PomTZ45ZjI+1TxgHx+T60fIb1Jpmu8
         UCJg==
X-Gm-Message-State: APjAAAVL0io9FtHRDi8ZWLqGL03s48AMCnmT6V2Ss8jzMgynFu01bK/k
        fnRvuGc2EePeToYDyRTzad7dhEHeKnJbk8z07JgZU3EIqTP0AQ==
X-Google-Smtp-Source: APXvYqy0QP80VPZNVVFWNjwhH9i2upZOEFybpazI+swP9S9KEN4IbRBAdgy5hHGEFO/jVMsbKvlD+1eguW1OHSHMjrY=
X-Received: by 2002:a37:a157:: with SMTP id k84mr3868576qke.141.1566999550483;
 Wed, 28 Aug 2019 06:39:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190828132245.53155-1-chenerqi@gmail.com>
In-Reply-To: <20190828132245.53155-1-chenerqi@gmail.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Wed, 28 Aug 2019 21:38:58 +0800
Message-ID: <CAAM7YAm2+GCPC6a9+Tr3TQRmLZpi7q0mLMjY7QnHoJBZUU_Kmw@mail.gmail.com>
Subject: Re: [PATCH] ceph: reconnect connection if session hang in opening state
To:     chenerqi@gmail.com
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Aug 28, 2019 at 9:24 PM <chenerqi@gmail.com> wrote:
>
> From: Erqi Chen <chenerqi@gmail.com>
>
> If client mds session is evicted in CEPH_MDS_SESSION_OPENING state,
> mds won't send session msg to client, and delayed_work skip
> CEPH_MDS_SESSION_OPENING state session, the session hang forever.
> ceph_con_keepalive reconnct connection for CEPH_MDS_SESSION_OPENING
> session to avoid session hang.
>
> Fixes: https://tracker.ceph.com/issues/41551
> Signed-off-by: Erqi Chen chenerqi@gmail.com
> ---
>  fs/ceph/mds_client.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 920e9f0..3d589c0 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4044,7 +4044,9 @@ static void delayed_work(struct work_struct *work)
>                                 pr_info("mds%d hung\n", s->s_mds);
>                         }
>                 }
> -               if (s->s_state < CEPH_MDS_SESSION_OPEN) {
> +               if (s->s_state == CEPH_MDS_SESSION_NEW ||
> +                   s->s_state == CEPH_MDS_SESSION_RESTARTING ||
> +                   s->s_state == CEPH_MDS_SESSION_REJECTED)
>                         /* this mds is failed or recovering, just wait */
>                         ceph_put_mds_session(s);
>                         continue;
> --
> 1.8.3.1
>
    Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
