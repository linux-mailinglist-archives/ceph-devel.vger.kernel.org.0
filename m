Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 119BA76370A
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jul 2023 15:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbjGZNGd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Jul 2023 09:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbjGZNGc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Jul 2023 09:06:32 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E727F1BF2
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 06:06:30 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-99bccc9ec02so65433566b.2
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 06:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690376789; x=1690981589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K6rt1IBDILT6lLKujjFtHx8R8SfUT9pqVJT/oJ4exYU=;
        b=NQyxbi7QmJcpcG3Z4chU2WXxw+1R+OdcyweAqSyWTZ0JdElZ/ouj2D2VwqbI8Jfqko
         qNd6k+5lkvF2y4FMK5Q47xotb+yb95Mj6moKWounOWZI0FIqYfkofOiaOAtSFMfwZIkd
         +KQxAMYK3AbmL2x4bJm1gxGRG3pMBfEhid2j7FfewIhEfL5+oQfV5VcPRWuI00/WQtwE
         fgVuybN4YXg8Ngi+OIfnTVxqGYzuP/RfsEpF0xedbcupCHbk+moe0YRL3COm5YX9vyM9
         Jkt2Qpv6lpcQ52+HPAB1UWkgZacs/lLQ14d7Zbp0IOPi8zu1mQe3X3Sl2Wt3h4K/owhR
         fxOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690376789; x=1690981589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K6rt1IBDILT6lLKujjFtHx8R8SfUT9pqVJT/oJ4exYU=;
        b=d6DuIvbJZnFFQq1hbx2M7ZDVL+k2Z3TLOJCg38gz6CTsYr0wGLhvvaj8/tqFPGNhch
         1rwD1c97DjqGlfnrxh818tL+qY415XsJsinZ1ovz43hwiDJsBabMOvol3K9t7TYVbNQq
         ZwesI5epMxjI01UYIo0ZcLivBb81s0S5mgSW5e5uk5lxxhJkkdwOlSRhnK5K5aJqM348
         HwFt80GskEmh8TV3YYSEvsl9uJVbRj7DuhvO9pMbNk9Ojkm0MD6l1NyOa7Z39xxSK1kz
         z4s288f6a1281Ph5YW5IMBvf3Qg9a3BohkFBxrknkAizQ1cSaf6trAYlaHiqH6TpMohe
         VpqA==
X-Gm-Message-State: ABy/qLagDB5IV2BtYszfpu2Dg+zqZv7WvsS+QyPDaV8GjeJcsfSr1FX2
        LEFxG6N0m7dTWz3qHK2bYa9NCLTRudBU+QAiYsB1Fv07+6E=
X-Google-Smtp-Source: APBJJlGTB5ANlO9/3wchbK7h35Yg2q98AeBviYPZevGX0ncthJLTZT9k+oLy/9GFQNfNWdEDNP/+ZmUTpK07+a1HYgA=
X-Received: by 2002:a17:906:310f:b0:994:673:8af6 with SMTP id
 15-20020a170906310f00b0099406738af6mr1583534ejx.29.1690376789167; Wed, 26 Jul
 2023 06:06:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230725212847.137672-4-idryomov@gmail.com> <AJYA4wAxJMc9WiAuqHSSGKra.3.1690375435133.Hmail.dongsheng.yang@easystack.cn>
In-Reply-To: <AJYA4wAxJMc9WiAuqHSSGKra.3.1690375435133.Hmail.dongsheng.yang@easystack.cn>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 26 Jul 2023 15:06:17 +0200
Message-ID: <CAOi1vP8tThg3MYP_w3SW842qn3=EKz0ns5VwPB7-QdQ_PKbsPA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] rbd: retrieve and check lock owner twice before blocklisting
To:     =?UTF-8?B?5p2o5Lic5Y2H?= <dongsheng.yang@easystack.cn>
Cc:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jul 26, 2023 at 2:44=E2=80=AFPM =E6=9D=A8=E4=B8=9C=E5=8D=87 <dongsh=
eng.yang@easystack.cn> wrote:
>
>
> From: Ilya Dryomov <idryomov@gmail.com>
>
> Date: 2023-07-26 05:28:46
> To:  ceph-devel@vger.kernel.org
> Cc:  Dongsheng Yang <dongsheng.yang@easystack.cn>
> Subject: [PATCH v2 3/3] rbd: retrieve and check lock owner twice before b=
locklisting>An attempt to acquire exclusive lock can race with the current =
lock
> >owner closing the image:
> >
> >1. lock is held by client123, rbd_lock() returns -EBUSY
> >2. get_lock_owner_info() returns client123 instance details
> >3. client123 closes the image, lock is released
> >4. find_watcher() returns 0 as there is no matching watcher anymore
> >5. client123 instance gets erroneously blocklisted
> >
> >Particularly impacted is mirror snapshot scheduler in snapshot-based
> >mirroring since it happens to open and close images a lot (images are
> >opened only for as long as it takes to take the next mirror snapshot,
> >the same client instance is used for all images).
> >
> >To reduce the potential for erroneous blocklisting, retrieve the lock
> >owner again after find_watcher() returns 0.  If it's still there, make
> >sure it matches the previously detected lock owner.
> >
> >Cc: stable@vger.kernel.org # ba6b7b6db4df: rbd: make get_lock_owner_info=
() return a single locker or NULL
> >Cc: stable@vger.kernel.org # c476a060136a: rbd: harden get_lock_owner_in=
fo() a bit
> >Cc: stable@vger.kernel.org
> >Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
>
>
> Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>

Hi Dongsheng,

Is this a review just for this patch or for the entire series?  The
patch doesn't apply in isolation, so I'm assuming it's for the entire
series but need confirmation since it's not on the cover letter.

Thanks,

                Ilya
