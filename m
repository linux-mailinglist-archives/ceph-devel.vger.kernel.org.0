Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D911E84A9
	for <lists+ceph-devel@lfdr.de>; Fri, 29 May 2020 19:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgE2RU6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 29 May 2020 13:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgE2RU5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 29 May 2020 13:20:57 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6AAC03E969
        for <ceph-devel@vger.kernel.org>; Fri, 29 May 2020 10:20:57 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id a14so3278164ilk.2
        for <ceph-devel@vger.kernel.org>; Fri, 29 May 2020 10:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GgL6hADCgD2ngb9C55J5xj301tQSX+W+XiUPyvKFsrQ=;
        b=CPxupVTtv6h3yR864esdwW/PxR6Wy2wexsQbl76Oeq9yawqv/4T2lgFFuhIpCsQHm7
         1eltFP3RDtIfQlFMQwhDp+h3HmnHUjlHtCK0vKERIT1haogQ3GhdcewBsd1sgzNQ0SYS
         q0viEagFsT8Lh63GEFJPx86+mPb4HFSyW7/vfkMuMwKDuCcJcxkxWRLGeURcJqXMs0R8
         NmfO3Y1AS8I4SNhkyeAh7vixN1Ysm0knCcXWjEKpyCVyeGvXd4v4CteSuUq8I5KCsm17
         l3iEFioT+eIvQHMNEbgDgLBj/o+15E5jVDj+UDw6GmJJTEx34iiP5riZC6xjvolY4Fyb
         E3ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GgL6hADCgD2ngb9C55J5xj301tQSX+W+XiUPyvKFsrQ=;
        b=rTB3d1FBrF34euYSZpcMrY3LU6x/lNdhyk1wl9P3naMkW0XlMdSZC3S127OQbCR4hJ
         ASe9YKR18NvKHiEEoRYnxvxf8u5uYScfWBIx08yrW8K+9/M7l/vNTgKtQ/nsCBYhEeGF
         Gd9PmpYAHdjyefoRlmDUaEZJgmDc6aBFFY0EAnCgDeZXMBMYL1YS7BPQwgC3dgwWlMgk
         H+n4sNydGrVkttIiO9vH6sHX9suLF6F8RW4udisMOn4G6XTwLyFW166F0UyV4Pn/5VN8
         R3JVYtnFuK0ih722s81Xd9d7/bmylSJ412cr47vCkXVtqP/zRPAVn4iXWPI0Az4fvm3L
         rqJA==
X-Gm-Message-State: AOAM532VLUuvdsIw7Vtj6y6O8X+KKuimE3etytTZYpHPH39a3gxWP06I
        oo7JYdUJ7EvWkLIzGDnHXoyDYwAMmIt9NfbZiZh17R6lZis=
X-Google-Smtp-Source: ABdhPJzaUlk8L5C2k1+bqVEQZSP3TZgsrB9IonsSdOrhBfBQhBN1SDwSPIXkTPmJtpqIU9LGlLIEt52ntbdhil8Z1Eg=
X-Received: by 2002:a92:bb45:: with SMTP id w66mr8687266ili.131.1590772857104;
 Fri, 29 May 2020 10:20:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200529151952.15184-1-idryomov@gmail.com> <CA+aFP1D_povJnBfH5pT8E7OVK_WHWa0TtBwRCxB=OmscTjGf8Q@mail.gmail.com>
In-Reply-To: <CA+aFP1D_povJnBfH5pT8E7OVK_WHWa0TtBwRCxB=OmscTjGf8Q@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 29 May 2020 19:21:02 +0200
Message-ID: <CAOi1vP83RsnP7JB2VGfCZv+hwLTDuuzC1vwJpvbX84NKSTZ6jQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] libceph: support for replica reads
To:     Jason Dillaman <dillaman@redhat.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, May 29, 2020 at 6:57 PM Jason Dillaman <jdillama@redhat.com> wrote:
>
> lgtm -- couple questions:
>
> 1) the client adding the options will be responsible for determining if it's safe to enable read-from-replica/balanced reads (i.e. OSDs >= octopus)?

Yes, we can't easily check require_osd_release or similar in the
kernel.  This is opt-in, and I'll add a warning together with the
description of the new options to the man page.

> 2) is there a way to determine if the kernel supports the new options (or will older kernels just ignore the options w/o complaining)? i.e. can ceph-csi safely add the argument regardless?

No, older kernels will error out.  I think ceph-csi would handle
this the same way ceph quotas are handled (i.e. with the list of
known "good" kernel versions) or alternatively just attempt to map
with and then without crush_location and read_balance=localize
(probably less appealing given that the kernel version list
infrastructure is already in place).

Thanks,

                Ilya
