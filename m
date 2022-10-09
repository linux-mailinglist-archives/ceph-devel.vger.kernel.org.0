Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4625F89CD
	for <lists+ceph-devel@lfdr.de>; Sun,  9 Oct 2022 08:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiJIGtl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 9 Oct 2022 02:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiJIGth (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 9 Oct 2022 02:49:37 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E97130
        for <ceph-devel@vger.kernel.org>; Sat,  8 Oct 2022 23:49:34 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id d26so11983212eje.10
        for <ceph-devel@vger.kernel.org>; Sat, 08 Oct 2022 23:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1ZLfh/kJniA0SsDArOwtDJ/ZRi0BuiUdpe++i/ajh6o=;
        b=fZfiGufQQshb7+Pel1YdxHFn0kuiiQg+LQo7JfynFTNca1yj3Q5JPSqnGQ8k7iYGBb
         pV/vL7MW8rrisN01RF+EdpJGjhwu2D0hwZC+2KG2fckSwXoCoYeIIbteLi7+ybu98YNb
         zsO5YcK5T45hXYJTaOMW7o2JHrjT0dcgKTixOZE4gKzG8LUXd49qtHe+65wZ9Urs6+J6
         n6inPPDvYzxbpokD2AoFX6gskwdQ+cY4CuWcc0WUUnODV7h/76tuKsfSceBveAToYi65
         R7bC5UHDhD5RzfNt/PxEGf+i+79gGxe440nmkew6sdlAs9CAX+iedW9sdQotybWxsGSP
         y/dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1ZLfh/kJniA0SsDArOwtDJ/ZRi0BuiUdpe++i/ajh6o=;
        b=2g8u/w23RkoQ8lheOZg6SfCassF8v9R/lF62p/vLBF2uaUqIhnxXWN8MDodu6vim6b
         znO3jGAcyi1+ka00urSu7zVz9UKJx1/NDrtjw63QvQnxE4vAcSJNOAFN/T34QC0uWxBW
         c9HLbUGDqt1ulGTRIQVUFSBN4LJH4MZ+YfdsX7GPKj0U39SUPLMP97cLfRGsJ33bv1BQ
         78AuhIgZO7kcN/cmEweD1zyIATn+dWte88pv6Jq4ubh3U78JAwS+xRp3uNy9FbdSNET7
         5VqZCSwclHpb+6fSd9NUTu+qnO0WHXY4PMDglU5JJ73f3Ki3GrS4e7QLb9Z8RzZfL/sI
         wJ0Q==
X-Gm-Message-State: ACrzQf0bBIsSqi9FHa1pXl7Fk+VRVtoYdgNFfMf+Eco6CHHesDKngHF6
        rmljgfgEcDY3XDGBX4T4WwpSFc3Rgh8RNXGUS08gUA==
X-Google-Smtp-Source: AMsMyM6ouWinsTaRGvOfpoqS+hMn/fYxvHX7lpgdiZ2lzKXkmaY1hziY4YGjX7yXGTpOSHHPXr9bgoogFgcLdAZf5eo=
X-Received: by 2002:a17:907:25c5:b0:782:978d:c3da with SMTP id
 ae5-20020a17090725c500b00782978dc3damr9999283ejc.623.1665298171163; Sat, 08
 Oct 2022 23:49:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220927120857.639461-1-max.kellermann@ionos.com> <88f8941f-82bf-5152-b49a-56cb2e465abb@redhat.com>
In-Reply-To: <88f8941f-82bf-5152-b49a-56cb2e465abb@redhat.com>
From:   Max Kellermann <max.kellermann@ionos.com>
Date:   Sun, 9 Oct 2022 08:49:19 +0200
Message-ID: <CAKPOu+88FT1SeFDhvnD_NC7aEJBxd=-T99w67mA-s4SXQXjQNw@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/super: add mount options "snapdir{mode,uid,gid}"
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, jlayton@kernel.org, ceph-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, Oct 9, 2022 at 8:23 AM Xiubo Li <xiubli@redhat.com> wrote:
> I don't think this is a good place to implement this in client side.
> Should this be a feature in cephx.

What's cephx? "git grep cephx" didn't reveal anything that looked useful to me.

> With this for the same directories in different mounts will behave
> differently. Isn't that odd ?

Just like different mounts can have different snapdir names currently.
That's just as odd, and I tried to imitate what's already there.

I don't have an opinion on how this should be implemented, all I want
is restrict who gets access to cephfs snapshots. Please explain how
you want it, and I'll send an amended patch.
