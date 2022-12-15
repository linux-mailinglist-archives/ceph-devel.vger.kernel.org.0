Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75CC164DDDA
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Dec 2022 16:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiLOPdO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 15 Dec 2022 10:33:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiLOPdM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 15 Dec 2022 10:33:12 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A24167DE
        for <ceph-devel@vger.kernel.org>; Thu, 15 Dec 2022 07:33:11 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id bj12so53048579ejb.13
        for <ceph-devel@vger.kernel.org>; Thu, 15 Dec 2022 07:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qwOz3nqs/LShCL+qayPl25Lxv1/+rQcudUkFbWqIIGs=;
        b=Mk7gP8Cv/h5bRlwbA4eAjO71JgJGuPXzPLOA+A8l9aTq1mMikfOhocETYTLD2FQ/eF
         2l8cHHMUEa84gNze5BUxfGWIYOf6zel33lokjr0j1eYwChccb/XyoZ+gvdSKJGXuC8qV
         MwNPHJnibDzb2WR6fSZD5HDZtqXSFflOcjqgStpEwFU1F7blD94vW59ljyXxhn2KLX7W
         A2x3H+4ebjJkRTPZGCBqJbety8OaYf31xzCbAP+TcUbXvGqBml9BwNBnh77J3eV2SboI
         71qr6H9I8ocytHR5/T82V27Vbi9VaEhx2anDc+bCpL8P8ktZkx4pX5SY0mkbGXVUre4i
         dR4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qwOz3nqs/LShCL+qayPl25Lxv1/+rQcudUkFbWqIIGs=;
        b=cwLCG4kZWy8/hG+f2guRI5VKc0y0ePOUsb7D+oTNeEiXUVZxQOBVU5eY5YEsOLxzXT
         azV36Eh4fp8GRf0S2WnlvP6uLuSaQMiobml1OkA2+0TD2Y5HgMrMt1Uq92DRe7MWy90+
         m/IcEMOfcJUARaROsWV1+f1KTpsGun9dPVYJDDqgjPEukWcpAYsEIJ0RqxGyk01YFfGH
         DCGo/qYOBSwJtKF8Bt3dR/F937ci9czSfagQZzhk4T2BYjLJS+P5OWQcpTbjnWMpRDvj
         VQGNmfIuDOYK/catmSX+7H/EZ/gnnl6v53BrHKTlicsALW+N+8aEU3ZFxj0WL9bOyejO
         MUPQ==
X-Gm-Message-State: ANoB5plJlqHIr8RaJrkeEYoxnZRDgKcEy2kS45IrfgXn/MUkmSy1HZEv
        r6FQqpDKU97xxP3cZmKGSN6LtJN5vtDp2Cvndko+Z6AC6c0=
X-Google-Smtp-Source: AA0mqf5FJdxTtvTjhTl2IkV4GLqADK8e8kE3ty1fmoXBYzJyWQxv48CErZo53jxBIoEzVyELlk7e0fJZLRMAS94uBTk=
X-Received: by 2002:a17:906:240f:b0:7c0:f7b0:fbbb with SMTP id
 z15-20020a170906240f00b007c0f7b0fbbbmr16474814eja.266.1671118390209; Thu, 15
 Dec 2022 07:33:10 -0800 (PST)
MIME-Version: 1.0
References: <fc2786c0caa7454486ba318a334c97a3@mpinat.mpg.de>
In-Reply-To: <fc2786c0caa7454486ba318a334c97a3@mpinat.mpg.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 15 Dec 2022 16:32:58 +0100
Message-ID: <CAOi1vP-J_Qu28q4KFOZVXmX1uBNBfOsMZGFuYCEkny+AAoWesQ@mail.gmail.com>
Subject: Re: PROBLEM: CephFS write performance drops by 90%
To:     "Roose, Marco" <marco.roose@mpinat.mpg.de>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Xiubo Li <xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Dec 15, 2022 at 3:22 PM Roose, Marco <marco.roose@mpinat.mpg.de> wr=
ote:
>
> Dear Ilya,
> I'm using Ubuntu and a CephFS mount. I had a more than 90% write performa=
nce decrease after changing the kernels main version ( <10MB/s vs. 100-140 =
MB/s). The problem seems to exist in Kernel major versions starting at v5.4=
. Ubuntu mainline version v5.4.25 is fine, v5.4.45 (which is next available=
) is "bad".

Hi Marco,

What is the workload?

>
> After a git bisect with the "original" 5.4 kernels I get the following re=
sult:

Can you describe how you performed bisection?  Can you share the
reproducer you used for bisection?

>
> ed24820d1b0cbe8154c04189a44e363230ed647e is the first bad commit
> commit ed24820d1b0cbe8154c04189a44e363230ed647e
> Author: Ilya Dryomov <idryomov@gmail.com>
> Date:   Mon Mar 9 12:03:14 2020 +0100
>
>     ceph: check POOL_FLAG_FULL/NEARFULL in addition to OSDMAP_FULL/NEARFU=
LL
>
>     commit 7614209736fbc4927584d4387faade4f31444fce upstream.
>
>     CEPH_OSDMAP_FULL/NEARFULL aren't set since mimic, so we need to consu=
lt
>     per-pool flags as well.  Unfortunately the backwards compatibility he=
re
>     is lacking:
>
>     - the change that deprecated OSDMAP_FULL/NEARFULL went into mimic, bu=
t
>       was guarded by require_osd_release >=3D RELEASE_LUMINOUS
>     - it was subsequently backported to luminous in v12.2.2, but that mak=
es
>       no difference to clients that only check OSDMAP_FULL/NEARFULL becau=
se
>       require_osd_release is not client-facing -- it is for OSDs
>
>     Since all kernels are affected, the best we can do here is just start
>     checking both map flags and pool flags and send that to stable.
>
>     These checks are best effort, so take osdc->lock and look up pool fla=
gs
>     just once.  Remove the FIXME, since filesystem quotas are checked abo=
ve
>     and RADOS quotas are reflected in POOL_FLAG_FULL: when the pool reach=
es
>     its quota, both POOL_FLAG_FULL and POOL_FLAG_FULL_QUOTA are set.

The only suspicious thing I see in this commit is osdc->lock semaphore
which is taken for read for a short period of time in ceph_write_iter().
It's possible that that started interfering with other code paths that
take that semaphore for write and read-write lock fairness algorithm is
biting...

Can you confirm the result by manually checking out the previous commit
and verifying that it's "good"?

    commit 44960e1c39d807cd0023dc7036ee37f105617ebe
    RDMA/mad: Do not crash if the rdma device does not have a umad interfac=
e
        (commit 5bdfa854013ce4193de0d097931fd841382c76a7 upstream)

Thanks,

                Ilya
