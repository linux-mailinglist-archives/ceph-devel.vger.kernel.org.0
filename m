Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECC65E036
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jul 2019 10:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfGCIvO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Jul 2019 04:51:14 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:45220 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfGCIvO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Jul 2019 04:51:14 -0400
Received: by mail-io1-f66.google.com with SMTP id e3so2528122ioc.12
        for <ceph-devel@vger.kernel.org>; Wed, 03 Jul 2019 01:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RafeZ7DO6Qb6BX0cz4owBbYhhI3se0YWB9dOg3H7bEY=;
        b=o4DjNJpW+VyIzx/tHhZcoeL0s6LKDd2bP7v+TV1leT7z7Xq8rAOKY/XQWhL9rLo8Ms
         MINk4vwqkuljsFaDtUc6CEQW7mjIm8qF4WqMBzslUnjO2ArQTo6+0NpGvD5SkOpyS/10
         d8byrGVIqSnpzhMqNyO1QjMIrWzUe9bi2IcG6zidYOEe3Cf/zpiAc5RyCeC9zYdq8UsC
         ILTj6CI1e8/z0enu2iWXTnjrr39h3tBzf7AP5p5S7J0PXrHf9Rnaa6T6RVe1l1m/0ctK
         xxG1z7VCcyZBOki7vUTG/D7FkTV2hwujNryySA9HDzZdXchsTVDTPCFqv/mFyvwAaeeT
         0ZgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RafeZ7DO6Qb6BX0cz4owBbYhhI3se0YWB9dOg3H7bEY=;
        b=HRb2vW/wTlpkBezOexJ1mDybfNllRvm40607KHGL2nA6oDGDc/NTM/wDnRyBF2mFMc
         flK61ubaeI/+95V0WoAWqdvj8zljDuM23DP2WXhKiWtWp86Gdct8yQeDXKnv1uSCvNsr
         KemCwDmpRYSSXEWU0CdB/TioIrl5XP4HXKZQN7B9mL95Rr6Jv92eYdaE3jVxs9l+UULq
         vhAYu3sijmmUBKzafD0mEfjvCbYePavf+LS9OAsWijmD5512wmGLYXMm68YC5seI1lRb
         /STLo/GxVLqN+NFjDsluIWrqypCw81S12EUmHniLf2x/Y/EdDLqFHx+RtYvc3ipg0DXJ
         bCRw==
X-Gm-Message-State: APjAAAUJ1H1nmQbttA5N6FGj4sMpDmUO7mWqwYdae5wluqfzBSTWTNfd
        JCgxlMuNU+eyREZK+sX7XiXKs4fqx3SzpH59eWU=
X-Google-Smtp-Source: APXvYqz+C0QJwTsEmboHU4/q+TI9Bn3CfmcuzQadT5xWudFbpQdZ2IPVoXd6tAe+p3kSoNKfSVxiVJoArMzNFzsIfXw=
X-Received: by 2002:a02:554a:: with SMTP id e71mr40620480jab.144.1562143873867;
 Wed, 03 Jul 2019 01:51:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190625144111.11270-1-idryomov@gmail.com> <20190625144111.11270-7-idryomov@gmail.com>
 <CA+aFP1C9pDBCT+a6E=xHD2w3Th_b9B-tQmY77=Zv05tfC0mB7g@mail.gmail.com>
In-Reply-To: <CA+aFP1C9pDBCT+a6E=xHD2w3Th_b9B-tQmY77=Zv05tfC0mB7g@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 3 Jul 2019 10:53:54 +0200
Message-ID: <CAOi1vP9s+GkatkYYxiA30=DdqbA2C9uF+yehomGsUPotRV24mw@mail.gmail.com>
Subject: Re: [PATCH 06/20] rbd: introduce obj_req->osd_reqs list
To:     Jason Dillaman <dillaman@redhat.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jul 1, 2019 at 8:34 PM Jason Dillaman <jdillama@redhat.com> wrote:
>
> On Tue, Jun 25, 2019 at 10:44 AM Ilya Dryomov <idryomov@gmail.com> wrote:
> >
> > Since the dawn of time it had been assumed that a single object request
> > spawns a single OSD request.  This is already impacting copyup: instead
> > of sending empty and current snapc copyups together, we wait for empty
> > snapc OSD request to complete in order to reassign obj_req->osd_req
> > with current snapc OSD request.  Looking further, updating potentially
> > hundreds of snapshot object maps serially is a non-starter.
> >
> > Replace obj_req->osd_req pointer with obj_req->osd_reqs list.  Use
> > osd_req->r_unsafe_item for linkage -- it's used by the filesystem for
> > a similar purpose.
>
> Nit: just curious on the history of "r_unsafe_item"'s name. Since it
> would be re-used twice for an osd request list, should (could) it be
> renamed?

This is from when we had safe and unsafe replies (commit vs ack).  It
has since become a private list item for use by libceph clients.  I'll
rename it to r_private_item.

Thanks,

                Ilya
