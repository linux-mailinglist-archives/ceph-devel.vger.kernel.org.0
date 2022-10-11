Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67175FAFC1
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Oct 2022 11:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiJKJ4Z (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 11 Oct 2022 05:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiJKJ4Y (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 11 Oct 2022 05:56:24 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677D5564F5
        for <ceph-devel@vger.kernel.org>; Tue, 11 Oct 2022 02:56:21 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id z3so18357122edc.10
        for <ceph-devel@vger.kernel.org>; Tue, 11 Oct 2022 02:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=al5nlRBkZUaeArvYaMOYERw5P26ERZ12iQU+5SXRj+8=;
        b=C+5zZRDMfeUNOFNEK0ikcwEBMR1f91BJd4fWIoJoc2y31eypKG1SNrIOarQt6dSLYF
         8SU8KiWpfC4pp2eNaSdaK72nHeLy/1NBe2iZTFjqFXaeDGBlvDF//gRZQkzIGZwm7jC9
         xrgY4vvwu1GeoFPXn8MuA4QHRDt4HkY39PEcfHb515xV8v0/n8QltH+fe2UzpzOQC+0t
         V20oBnO4E6vmzecBR+OgTg0BUxNRhUkjXWTLuI68OtjKITl32F4EKbzPHmEApFu3PGaf
         sfKs7H2cCL7ZHaSYzvjXSi4+F8EmrE1EJd8C0zz05qwsmyLu7Rny5AabGwGqiRYVkvP+
         WB8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=al5nlRBkZUaeArvYaMOYERw5P26ERZ12iQU+5SXRj+8=;
        b=o+n06ZGdkEXHEM4EdHBvoTxqbWkH3gpeFcNRcG4B8lXgaz+NcE69EjgNVEsgC4HcPi
         0ut2CsaNAmbsN5OHfFakIZghpu32gf1r+6aCQD4WnJ8Z8uDXVdF0hxpE5gScRwlL6Z2X
         g0HKyg84Jvqr0mBiVTuYkRBCtvpiie6i8pIkW7+xWX4XkCzKsfQ7o9D6sYLYwbTwfmk9
         BTDqItatfG1M5tfDBMdy5I4l5ShUw1ZtNpM52MFB1FmvNOL3AToqK+Ps3Acw39u4S8F+
         mQVbl704xN6pdmHLQL03CfOpe75bgPGw58hK0Fa6UUeKt+7I6YJdQUWUxT4xfG3Lj/LX
         6BkA==
X-Gm-Message-State: ACrzQf0UAAGfQUl1YZnsk4FUAXlstOiXwdiNumsA4+JV8c82OdAL688C
        1KdUszN8FH5z+BUrMGP2m3zQOAdOijiXjPiETNwVlvPK/sxnMw==
X-Google-Smtp-Source: AMsMyM77oqtzxqjs6qGlzaM86MzIf7sIxR+36RH2i2KB52JOqb9/AgKiHyqA/trDZkU/nfjyoelR9hGJoJYTMIIkRtw=
X-Received: by 2002:a05:6402:448:b0:45c:8de5:4fc with SMTP id
 p8-20020a056402044800b0045c8de504fcmr709316edw.133.1665482179950; Tue, 11 Oct
 2022 02:56:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220927120857.639461-1-max.kellermann@ionos.com>
 <88f8941f-82bf-5152-b49a-56cb2e465abb@redhat.com> <Y0U3UAjugtpOlJqn@suse.de>
In-Reply-To: <Y0U3UAjugtpOlJqn@suse.de>
From:   Max Kellermann <max.kellermann@ionos.com>
Date:   Tue, 11 Oct 2022 11:56:09 +0200
Message-ID: <CAKPOu+9Koyj5fKqdd=QjcSgCesMoW+7FN2a=dwEH+c_mDgNo8g@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/super: add mount options "snapdir{mode,uid,gid}"
To:     =?UTF-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
Cc:     Xiubo Li <xiubli@redhat.com>, idryomov@gmail.com,
        jlayton@kernel.org, ceph-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Oct 11, 2022 at 11:27 AM Lu=C3=ADs Henriques <lhenriques@suse.de> w=
rote:
> I'm not really sure where (or how) exactly this feature should be
> implemented, but I agree with Xiubo that this approach doesn't look
> correct.  This would be yet another hack that can be easily circumvented
> on the client side.  If this feature is really required, the restriction
> should be imposed on the MDS side.

I think this is the wrong way to look at this problem. This is like
saying the client can circumvent file permissions by pretending to be
the owning uid.

This isn't about restricting a client to see/create/delete snapshots;
we need to agree that this is about clients which already have the
permission to do this. This is about restricting which users (uids) on
a client will be allowed to do that. The server cannot possibly
implement this restriction; all it can do is give kind hints to the
client, like it currently does with regular file permissions. But it's
up to the client's kernel (the cephfs driver and the VFS) to enforce
those per-uid permissions.

This approach is already implemented in cephfs currently. All my patch
does is allow overriding the mode mask, instead of inheriting the
parent's mode mask. So if you say "this approach doesn't look
correct", then you're actually saying that cephfs which is shipped in
Linux mainline kernels isn't correct. That is certainly a reasonable
opinion, but it's not about my patch.

> (However, IMHO the feature looks odd from the beginning: a user that owns
> a directory and has 'rw' access to it but can't run a simple 'mkdir' is
> probably breaking standards compliance even more.)

There is "prior art" for that: read-only mounts and immutable files.
On both, you can have the "w" permission bit but cannot actually
write.

Max
