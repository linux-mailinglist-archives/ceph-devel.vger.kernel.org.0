Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D561D9304
	for <lists+ceph-devel@lfdr.de>; Tue, 19 May 2020 11:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgESJOO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 May 2020 05:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbgESJON (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 May 2020 05:14:13 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6D9C061A0C
        for <ceph-devel@vger.kernel.org>; Tue, 19 May 2020 02:14:13 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id 18so3784085iln.9
        for <ceph-devel@vger.kernel.org>; Tue, 19 May 2020 02:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EihVy990ax59f8qYWJnk71P6cBCn2lfy80qtLDvPwEI=;
        b=ekH6YdQVTPzxfLJzxIWgBKa4RWBKwDmzwypRYWp3QKXgb/OuOZJ9tHGI/yJcnkipyt
         VWQe1aZ45QH7imvgX4imL3eRKaE5nJwhz0gjOFEDh2Z+IqlAZS/06d2oNyuIcEM4XOih
         6Jx3IGpYs2le5zD5x1OwCcdUrhb8Q2m1Lu03esopV8YmbnOEwT/gFn/i2FSRo7MPnszQ
         CDF8Hgr+FFdNyhRFQKS3HiD+HEWi1+iDiWy37lWEa9QElrOTMABhOhnsG7v1wYOIn8i0
         sEz+gPDYbCURJWV5oGCl5mVdzT36LetrjF3U+hpPLFDzFheJGAaMYo8npn923TivFV+z
         EjCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EihVy990ax59f8qYWJnk71P6cBCn2lfy80qtLDvPwEI=;
        b=Oj68Tbt52U/kt9PcnYxIc0wR1iTWxRbXeLJNwnRcswwfHyt8Tl/Mx0LiKiZYiML3zA
         icUjf9JhLxGpyM6++gNWKieWY+BPfUU7k/jypL+4gDiNwbIZVBNIsKJoKZFa1PeHQMM7
         LzVNtYkGAU6lRZPC3e9HkwNYRXE+f9gT03GPMlFSJPMbS1pEpiYCqxAHd2wWxZGwqLS+
         OBOALRfIHqbLmiJuybLVtwobiMCcV+8L7nQIIgt+i+nUta6/35Tn0JAtWWyHZrrAb6C8
         w+1NLC3CBBRuM8NngnDGuFkLALNoxM5yMC8MF3czB/5+ErbUvDjbJXIDcsB266eLff8L
         uHGg==
X-Gm-Message-State: AOAM533zQFUHSgnyZuWv9azFqPycHPeWKU5M8Fwr+Mb/cbW6sEUVNWYg
        u21O1GubnTBmOIkPOQlW4gHK61IoTCk8n0ZuouvjT+cG
X-Google-Smtp-Source: ABdhPJysiw/vpGRFgQtFIA3Uh6UZUywkQhgzd1TuQlWSomLPTee2EE1HaRMCWRdCMaErWqA/nzrMZSVdCB6HSfkaURI=
X-Received: by 2002:a92:8946:: with SMTP id n67mr17713982ild.215.1589879652724;
 Tue, 19 May 2020 02:14:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAKQB+fug_Y4y8wYe-vG=itf+0BmYFPfDm-ch7DTobtkipQz-yw@mail.gmail.com>
In-Reply-To: <CAKQB+fug_Y4y8wYe-vG=itf+0BmYFPfDm-ch7DTobtkipQz-yw@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 19 May 2020 11:14:17 +0200
Message-ID: <CAOi1vP-uF1_0R=5LApR=rdTXSzDWJq3LzuOYPrPmC_TPL909qA@mail.gmail.com>
Subject: Re: [PATCH] libceph: add ignore cache/overlay flag if got redirect reply
To:     Jerry Lee <leisurelysw24@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, May 18, 2020 at 10:03 AM Jerry Lee <leisurelysw24@gmail.com> wrote:
>
> osd client should ignore cache/overlay flag if got redirect reply.
> Otherwise, the client hangs when the cache tier is in forward mode.
>
> Similar issues:
>    https://tracker.ceph.com/issues/23296
>    https://tracker.ceph.com/issues/36406
>
> Signed-off-by: Jerry Lee <leisurelysw24@gmail.com>
> ---
>  net/ceph/osd_client.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 998e26b..1d4973f 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -3649,7 +3649,9 @@ static void handle_reply(struct ceph_osd *osd,
> struct ceph_msg *msg)
>                  * supported.
>                  */
>                 req->r_t.target_oloc.pool = m.redirect.oloc.pool;
> -               req->r_flags |= CEPH_OSD_FLAG_REDIRECTED;
> +               req->r_flags |= CEPH_OSD_FLAG_REDIRECTED |
> +                               CEPH_OSD_FLAG_IGNORE_OVERLAY |
> +                               CEPH_OSD_FLAG_IGNORE_CACHE;
>                 req->r_tid = 0;
>                 __submit_request(req, false);
>                 goto out_unlock_osdc;

Hi Jerry,

Looks good (although the patch was whitespace damaged).  I've fixed
it up, but check out Documentation/process/email-clients.rst.

Also, out of curiosity, are you actually using the forward cache mode?

Thanks,

                Ilya
