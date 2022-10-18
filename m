Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E162D603699
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Oct 2022 01:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiJRXTt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Oct 2022 19:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiJRXTs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 18 Oct 2022 19:19:48 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27431C92D
        for <ceph-devel@vger.kernel.org>; Tue, 18 Oct 2022 16:19:45 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id i16so6254501uak.1
        for <ceph-devel@vger.kernel.org>; Tue, 18 Oct 2022 16:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0SJhTm58jcZ66VMcJo9uIhg6zvMUfI9wHJDhj7OGHUQ=;
        b=N+/YxEyb/kVXB7dmLfvirOhcBB0LJMtu1pkedCONTFs7ZlPK7c4tlHTzprMGM+g+K4
         bqTJ4bT64ELEP5aE6D6qDmVxTncwvifyIC7kqlgpJF07hWnK4D2H5jIGOb4cB03wXN8b
         oVVs8mzgK5afsa+w6CPJQbqu40OL2I+SUy/iZIQ2MIJGJfaGrS2+hMrxTJ/bYzHIjjT9
         6T4a/erA4jBBVJrgLGn9CRVPen/7Qs0wbSsZWXS5nk+VU4pGC5ZN9FqItrVwJNfcLiUS
         RWj9g0cnNYJRimpaKGx+Sb5i8XEg7AbRFUeMsFsh8DaNrx7vwvJIxQ1b9QNwnbWIFlwN
         pbaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0SJhTm58jcZ66VMcJo9uIhg6zvMUfI9wHJDhj7OGHUQ=;
        b=rTWKcd+8Vzep3ydk3gCnmHpizDdAGUzctFGiLYQK5UuDDNNRbA2M0E+70HQI+4paHO
         aBFpbpNfDVkKxuGUTxNG/eCT7xc9KpmZOYbZU1XuVjgJ3UslHaTkODkQht0Vo1eKODG5
         kAETJngatkBUEQjTeO0y/SsfMPdG4rD1nntc50WA4k366xhTChgyzcHmwkw53+RnCzSo
         AHXzmyrLlXRmmiej7tJjLCj5tcCDLDjiddr71aufSJMEZ9TVIRmz8S18azbn3edXRz5u
         IlQvh4dRgNI7fyFny0Guh6nnZ8X6Maq//hmXaZGjATe4TAb5V26xKuOyV1cg4ysijnO9
         GfIA==
X-Gm-Message-State: ACrzQf2rBkmvEpGYTqxncFlMBv65H6OlN2dNhpGPZj5xzJV5lOUXutaH
        OTvwYESpR7Y3lccyeq/T52aNCqYlirZB9QcUW+58Ix0UUHU=
X-Google-Smtp-Source: AMsMyM7Xay+G8X80kg64m7BH/NW/wO2nZ+0GiGwyz/+Qynra5X7OLqZTLgM6Cz7T84850EENjcCEl6SXq8Fh4j+FW1E=
X-Received: by 2002:ab0:3b18:0:b0:3d1:f407:1190 with SMTP id
 n24-20020ab03b18000000b003d1f4071190mr457047uaw.51.1666135184755; Tue, 18 Oct
 2022 16:19:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAMym5wsABmduNp=JvwutFioiq24Qtm=fniKDDxqatFhpk_teYQ@mail.gmail.com>
 <CAJ4mKGYaNi2HNB4o9SPQgNw5ba0OAOWXDHZLM77KOgnht4--_g@mail.gmail.com>
In-Reply-To: <CAJ4mKGYaNi2HNB4o9SPQgNw5ba0OAOWXDHZLM77KOgnht4--_g@mail.gmail.com>
From:   Satoru Takeuchi <satoru.takeuchi@gmail.com>
Date:   Wed, 19 Oct 2022 08:19:33 +0900
Message-ID: <CAMym5wtoGkJvAYZ9ULirY-apXez4Vu4AXUA-NtX+1+qHivHFVQ@mail.gmail.com>
Subject: Re: Is downburst still maintained?
To:     Gregory Farnum <gfarnum@redhat.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Kyrylo Shatskyy <kyrylo.shatskyy@suse.com>
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

Hi Gregory,

2022=E5=B9=B410=E6=9C=8819=E6=97=A5(=E6=B0=B4) 2:19 Gregory Farnum <gfarnum=
@redhat.com>:
>
> On Mon, Oct 17, 2022 at 7:30 PM Satoru Takeuchi
> <satoru.takeuchi@gmail.com> wrote:
> >
> > Hi,
> >
> > I've tried to run teuthology in my local environment by following the
> > official docs.
> > FIrst I tried to use downburst but I found that it hasn't updated for
> > a long time.
> >
> > https://github.com/ceph/downburst
> >
> > Is downburst still maintained? Currently, I prepare my nodes by
> > Vagrant and would
> > like to know whether my approach is correct or not.
> >
>
> I think downburst is mostly dead at this point. The upstream lab
> teuthology instance no longer uses VMs or bursts into the cloud (it
> deploys using FOG to raw hardware), and I'm not sure if anybody else
> is keeping the run-on-a-cloud portions alive. :/
> I see Kyr committed to downburst about a year ago, and most of the
> vaguely recent work for clouds was from him and Suse, so maybe he
> knows?

Thank you for your answer, and I found I posted this message to the wrong l=
ist.
I should have sent this to dev@ceph.io or ceph-users@ceph.io.

Best,
Satoru
