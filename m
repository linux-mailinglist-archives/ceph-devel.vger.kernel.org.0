Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164C41AD9A2
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Apr 2020 11:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730199AbgDQJSl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 17 Apr 2020 05:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729987AbgDQJSk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 17 Apr 2020 05:18:40 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF154C061A0C;
        Fri, 17 Apr 2020 02:18:40 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id b18so1503034ilf.2;
        Fri, 17 Apr 2020 02:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iRWCVuq8TR2XzOv4hPXtI5URv7oqkeobScmDBMw46jU=;
        b=I3NV9c53UUyM+RaFHpaI3ddEqtHTMNLrpnXEObfjp0e0mHLbguamjM20GafXHlc3ed
         ZGR/ZJCgwJokyUJglSd8c8jXSWA9HKTJ5lwa7PCJGUsB+lbLZmvaasQt2pPpdEdT/WVm
         frwUxDFnqxiS7bXG3yIqc7hmziyca70GVFOoKiSxseXhjKCcjYhqorn/jTqZKBdNQisF
         AeOgu2i9w8/V6FSnr1gn2bOVuP+2Wb4uUtQbOD0DoqJnrGEWqRAPh/4CZ5DsYZFZNPc1
         ns/6haYvqe0+gX3iZFgzvO7T8he9vfmOpoEeCOXB4RCCed9cEq0+7mVvTssFlwcKrxWV
         E+Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iRWCVuq8TR2XzOv4hPXtI5URv7oqkeobScmDBMw46jU=;
        b=S+tbhKWbJSjXesJXz5yxGpoUh6INbLcps+urWhFEglaLTS3ZJ09EjiNB04At5Trak6
         Tl3OKhzlKwxxmPmxpxtT4ZGFt/3o7rucoVKNn3xDbizWb1nISvD+SQtuz9Gz+Vuo8hxn
         dF8/6pxhoA9jKi6Qwsy2K8unb9tqZDVENFcq+FreDN/QiF1+zUy/ujF9kYkaxremdRM6
         CwNJEeUb+H4166V/NQpi02Mzlf/V1nCVTBf6sHfq81yBPHZVjJVmDIEFfZImPdEr8jO8
         v3BRC0IshiYGjldsVwfYj7r1nMLPE2tMEpsWMkzfgKGkj1evKB9KrlSoF0s5bHa5inIz
         FUSA==
X-Gm-Message-State: AGi0Pua6bIdlZ2Fe/iIKjJcBTSXJDl1tS0qx4HBbqzsRVC6jitgSLFQV
        yuJcz7jLtEU4fYLWj662x3GfSXEgJy+UIGVnrN8=
X-Google-Smtp-Source: APiQypKLyZ1z8R9Bx3IFvmWATyK0p8QJ4t3dDqh+zoZfH4RuQzi8Op4IhAENVB998tQ83oZfu05nhEp28YrHD9cq+bY=
X-Received: by 2002:a92:dc8d:: with SMTP id c13mr1915098iln.278.1587115120296;
 Fri, 17 Apr 2020 02:18:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200417083448.9122-1-gmayyyha@gmail.com>
In-Reply-To: <20200417083448.9122-1-gmayyyha@gmail.com>
From:   Yanhu Cao <gmayyyha@gmail.com>
Date:   Fri, 17 Apr 2020 17:18:29 +0800
Message-ID: <CAB9OAC2VvwM5+L=N09Y-usxyXFRnzWFs8iN-zLHyEz7-twPOmQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: if we are blacklisted, __do_request returns directly
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

DNM. will add test mount option recover_session.

On Fri, Apr 17, 2020 at 4:35 PM Yanhu Cao <gmayyyha@gmail.com> wrote:
>
> Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
> ---
>  fs/ceph/mds_client.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 486f91f9685b..d2ea755b7c02 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2708,6 +2708,11 @@ static void __do_request(struct ceph_mds_client *mdsc,
>
>         put_request_session(req);
>
> +       if (mdsc->fsc->blacklisted) {
> +               err = -EACCES;
> +               goto finish;
> +       }
> +
>         mds = __choose_mds(mdsc, req, &random);
>         if (mds < 0 ||
>             ceph_mdsmap_get_state(mdsc->mdsmap, mds) < CEPH_MDS_STATE_ACTIVE) {
> --
> 2.24.2 (Apple Git-127)
>
