Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD4981104E5
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Dec 2019 20:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbfLCTQ4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 3 Dec 2019 14:16:56 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:41847 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbfLCTQ4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 3 Dec 2019 14:16:56 -0500
Received: by mail-io1-f65.google.com with SMTP id z26so5036849iot.8
        for <ceph-devel@vger.kernel.org>; Tue, 03 Dec 2019 11:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nWNXZUxg6DXwTopAZmZ9+iGoLTQA5nV5bgiJWZwftlY=;
        b=Q9xTbB5+hrqOHNyz5MToEk+WKWhWnAGSI01/moxtB6UDAxLPJ+0EqJpWeNh9YREmoV
         HTJkA7YKa3JfZVJveBN7G2+op2RMkilqaX01rfFYCCKnfJLeNhROXO0syYJ1Kn4kDNfc
         gwT6KDFP/3vzd/0spnUjHtWCYmi9SnbRbeocjxn40aYAdIK7FmqSjfAiHkfrQGdqcnns
         CNUxL6x3F2t487JjX+lLUQeiQXzElF+J8cyfbqlNkHVkykQn8b6G9BYqi9tkWW9xahq7
         Mzu2vc1CSw6Bb3FEehoI+An1IfQGWONBDQQL0jhaVI8q38iTMGYYjmqPT7tkmpce/RK/
         reFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nWNXZUxg6DXwTopAZmZ9+iGoLTQA5nV5bgiJWZwftlY=;
        b=UEIXQHA3wpobHlrKe8u2+BrO2SXI5ssIMjLS7umEpIZhTvNQLBEdcG5XBXsrBi8HaF
         CpEuV6BIZAnayh/zGFXDVvjwFeyGcKqwfPaHbPh1/DGv9zux10WLf9PCI+YKN5zxe3TN
         kfI/vaa8dmK4T9hOFkA7/Z/Q23knyoU8ddRc55dxBTN4OtYljxhyP83XaQngksmkNqA9
         EajHDooi4olB68oks5SzrF4z5ZtFPDVoMeD54DCleiVCvuZ9GMEoRa6PxhQDyWicPjLv
         8ZTYclUtVT7bFWKMi1nVeOcvp9cl/NihVGG4UQBYYXBD1pnMPOF7nIDPiWsbdQ8zayHK
         3qJQ==
X-Gm-Message-State: APjAAAWnsADpHyweF3tqk7mGZ6L4piVqwZ+b77kGAxX84t622JumoOF4
        GNKYnCSndo4LlKUn8Cx2l2fm6KqGRyDRk76KoDg=
X-Google-Smtp-Source: APXvYqwmK4xUeIys82mANFTj7M6UYQ+PXBiLSGR0tx8y3qZu1Vbj7LTn+MxszavyMwgFN8opK8AxWuztZWOXJmH9NwY=
X-Received: by 2002:a02:7102:: with SMTP id n2mr7067806jac.76.1575400615757;
 Tue, 03 Dec 2019 11:16:55 -0800 (PST)
MIME-Version: 1.0
References: <20191203142949.34910-1-xiubli@redhat.com>
In-Reply-To: <20191203142949.34910-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 3 Dec 2019 20:17:37 +0100
Message-ID: <CAOi1vP816t4vFznuP91TvA9UTZO63Esidkdp5UOHr-QxUThrNQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix mdsmap_decode got incorrect mds(X)
To:     xiubli@redhat.com
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Dec 3, 2019 at 3:30 PM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> The possible max rank, it maybe larger than the m->m_num_mds,
> for example if the mds_max == 2 in the cluster, when the MDS(0)
> was laggy and being replaced by a new MDS, we will temporarily
> receive a new mds map with n_num_mds == 1 and the active MDS(1),
> and the mds rank >= m->m_num_mds.
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mdsmap.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index 284d68646c40..a77e0ecb9a6b 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -129,6 +129,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>         int err;
>         u8 mdsmap_v, mdsmap_cv;
>         u16 mdsmap_ev;
> +       u32 possible_max_rank;

I think this should be an int, like mds and m_num_mds,

>
>         m = kzalloc(sizeof(*m), GFP_NOFS);
>         if (!m)
> @@ -164,6 +165,15 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>         m->m_num_mds = n = ceph_decode_32(p);
>         m->m_num_active_mds = m->m_num_mds;
>
> +       /*
> +        * the possible max rank, it maybe larger than the m->m_num_mds,
> +        * for example if the mds_max == 2 in the cluster, when the MDS(0)
> +        * was laggy and being replaced by a new MDS, we will temporarily
> +        * receive a new mds map with n_num_mds == 1 and the active MDS(1),
> +        * and the mds rank >= m->m_num_mds.
> +        */
> +       possible_max_rank = max((u32)m->m_num_mds, m->m_max_mds);

... making this cast unnecessary,

> +
>         m->m_info = kcalloc(m->m_num_mds, sizeof(*m->m_info), GFP_NOFS);
>         if (!m->m_info)
>                 goto nomem;
> @@ -238,7 +248,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>                      ceph_mds_state_name(state),
>                      laggy ? "(laggy)" : "");
>
> -               if (mds < 0 || mds >= m->m_num_mds) {
> +               if (mds < 0 || mds >= possible_max_rank) {

... and avoiding sign mismatch here.

Thanks,

                Ilya
