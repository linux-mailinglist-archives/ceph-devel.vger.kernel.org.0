Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2B011913DB
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Mar 2020 16:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgCXPF5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 24 Mar 2020 11:05:57 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:36702 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727314AbgCXPF4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 24 Mar 2020 11:05:56 -0400
Received: by mail-qt1-f195.google.com with SMTP id m33so15184883qtb.3
        for <ceph-devel@vger.kernel.org>; Tue, 24 Mar 2020 08:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hSUGzKvsG6sOU/qds7/USLgG/3bMm9C9PEfodxLyrRg=;
        b=NW/ULIpc1DhMWk4+vgDk9OKai3kMryy/D9tkbepvzeV+UNLZehXBdvmdUjWSlV3pk4
         ssu98OTAquyDEAewKUa9tQnfzhlgKa26tjE5oCpwoACFTSMphK0mj1v/IpfKrVcxy43c
         xwLNC4H0fYykBMXQwvvx0P+hwp+cuYFM6Uz5Ipz5nD9X0beS7VMWsuK7oPmfN9cWqben
         x+De2tX0QG0VGbWdbxjnWWuK7lvJPdeV5STJphjuxoQQ3pvVBqODsh3Eex2XGwsgSVs2
         RMIISAIhPk+g8rjRoAveStcFrAsoBmT9Wpz5kz6x3td0fpWEq/W7SmWKj7zKkKpcjvId
         toiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hSUGzKvsG6sOU/qds7/USLgG/3bMm9C9PEfodxLyrRg=;
        b=uNqU3VrwV5q5qCStktjbQC1usF7Acr6jkucSuvy9jQGnU6+4gRtf4xgDU6pJSl7Srd
         JgL+5TO3naTLfHB33OpGv9Jj51DnQUyMYIbfk/+D/6gSRma14TxZJb5JA0IsqrYDUiT6
         c0GkVE8/oM/NX/VdmVV7ByuxF5fxtLBx3KUPU91imOemcIjjrvr11zm0nSXPrazOZxFQ
         ou72DqQ1+o7ttCumBJdkO2w8n8FiT872wKySaIOhYus6S1bZEN2SfU3esfUgg5FPILai
         zSpgx3RhikV60Gxpc6IAXTdNuSRq8c8uShefwh9o5r7z7aGYxEz3kjJXcM1LsMYPGxKe
         iiGg==
X-Gm-Message-State: ANhLgQ1XHhBkk2JWShPwA0/fpfDj6jDYbiLoBRrUm2llmG76Txjn+z5r
        QpqOeNOkdtTeqgEXT0rMD4IZt7gH8WJMLWHIr6g=
X-Google-Smtp-Source: ADFU+vvGIc05HOoCwBf9XJewkomF+AWsBK9+Hf29uek+BF9Z+MiLwu8G1KaPyFPTchejvigW7ej+Gynm6bD40jAR08A=
X-Received: by 2002:ac8:3656:: with SMTP id n22mr26829887qtb.296.1585062355699;
 Tue, 24 Mar 2020 08:05:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200323160708.104152-1-jlayton@kernel.org>
In-Reply-To: <20200323160708.104152-1-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 24 Mar 2020 23:05:44 +0800
Message-ID: <CAAM7YAmJ6cCyPj6spnUjrGkE=9w4p2gwbyVb-VhFhj2OBRZH7A@mail.gmail.com>
Subject: Re: [PATCH 0/8] ceph: cap handling code fixes, cleanups and comments
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Mar 24, 2020 at 12:07 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> I've been going over the cap handling code with an aim toward
> simplifying the locking. There's one fix for a potential use-after-free
> race in here. This also eliminates a number of __acquires and __releases
> annotations by reorganizing the code, and adds some (hopefully helpful)
> comments.
>
> There should be no behavioral changes with this set.
>
> Jeff Layton (8):
>   ceph: reorganize __send_cap for less spinlock abuse
>   ceph: split up __finish_cap_flush
>   ceph: add comments for handle_cap_flush_ack logic
>   ceph: don't release i_ceph_lock in handle_cap_trunc
>   ceph: don't take i_ceph_lock in handle_cap_import
>   ceph: document what protects i_dirty_item and i_flushing_item
>   ceph: fix potential race in ceph_check_caps
>   ceph: throw a warning if we destroy session with mutex still locked
>
>  fs/ceph/caps.c       | 292 ++++++++++++++++++++++++-------------------
>  fs/ceph/mds_client.c |   1 +
>  fs/ceph/super.h      |   4 +-
>  3 files changed, 170 insertions(+), 127 deletions(-)
>

Other than minor comment for the first commit, this series look good

> --
> 2.25.1
>
