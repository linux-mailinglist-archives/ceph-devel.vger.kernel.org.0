Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7D92BBC54
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Sep 2019 21:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbfIWTlN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Sep 2019 15:41:13 -0400
Received: from mail-io1-f45.google.com ([209.85.166.45]:42905 "EHLO
        mail-io1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728033AbfIWTlN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 23 Sep 2019 15:41:13 -0400
Received: by mail-io1-f45.google.com with SMTP id n197so36408093iod.9
        for <ceph-devel@vger.kernel.org>; Mon, 23 Sep 2019 12:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jK9Y//+cFsxMeb3vADmP6uivnmHsMWatmt/NxFneOEw=;
        b=B1IYkY980jC6tImyMiYKbOxWA5NpXp421h5ICWSv4hpUDiEKnvTgMz15Dw6dE+uPaC
         HRZ6i4dtk1oZHl8b0/k8qlAYbgrgVndTkgOZBO0sndQOjivcm1zCZkRV1/w3UHjgufCC
         gWBd1hJ2dxsenUXpC1dxUdTjp1+pWocaPwJw1ZUNY2fYgK/VaKiTbRqgDMGQBkI/swnB
         T/72FIRJ0FS2loc8D0kGtf+oUYLdS520qYRljdqQp2MPOOvZsSCuL2nInKcC3oZC/PJB
         fSDFUuvbTgLycNRlvpnK7ZmN263PJni4Xoz35R8xHflqhtUzW95e2W6g8NsV+g4NU+2i
         Vssg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jK9Y//+cFsxMeb3vADmP6uivnmHsMWatmt/NxFneOEw=;
        b=ubixa5W+oOXvRippaGEpNSjgoIlhxx9eNIleWohZXqCKUu2xlOgvXPEdkh2cXqlQkL
         60AuKJidfUv9w1ZZgJKiBs6fGx41sTJbRcVvzbnM9UzWkTXG8KEG01IQ6nPTVUASv1b4
         7qLXzRHsIo87WV2uYDnmj1JLSd14yiDQdxy6VEUd4pXN0vrtvlVUa9UlQo5Qt5CRMPmE
         GQotFbjtrG29yGt85V3RYsUP4afNhNF+svWxIc+jQQYqMP7jHM+VwEUDmqFhj++U33Vk
         S86wv9baGtQCciTJTEMHGnGKSl1rv2cw1RfchhVMxu855DmbMXPgQ12kXceyyf5o7AIE
         z3Pw==
X-Gm-Message-State: APjAAAWZeGR0onB9OtaejY9zmNSPdDcVzPzqhAT2SmNw6CmISI/g7cs5
        EWJrImcmeSANSheAQvFqoUSG4x7v2ru4tt89DmM=
X-Google-Smtp-Source: APXvYqxNmzxIGR+xi+w5ZWrGIqjEOp+Ji5ccnyWnR16YvIsnFAtrB08cLi16qEhaKjGwcj9j9dm03GjUDA5ZU+Ice5Q=
X-Received: by 2002:a5d:9f4e:: with SMTP id u14mr1203237iot.106.1569267672304;
 Mon, 23 Sep 2019 12:41:12 -0700 (PDT)
MIME-Version: 1.0
References: <12d3b59259ebf2810c866c863445a68ea1f172c6.camel@kernel.org>
In-Reply-To: <12d3b59259ebf2810c866c863445a68ea1f172c6.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 23 Sep 2019 21:41:04 +0200
Message-ID: <CAOi1vP_bO-0c2prJQ=yaZoyrL1sVekcQN=c1-JK+x5zMVbLL8Q@mail.gmail.com>
Subject: Re: ceph-client/wip-* branch cleanup
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <ukernel@gmail.com>,
        "Dillaman, Jason" <dillaman@redhat.com>,
        Michael Christie <mchristi@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Sep 23, 2019 at 6:45 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> We have a bunch of branches in the ceph-client tree with the prefix
> "wip-" (see attached file) that are all well over a year old.
>
> For consistency with the other jenkins build trees, it would be good to
> be able to have it build any branch that starts with "wip-*", but if we
> turn that on now, it's going to try to build all of these old branches.
>
> Would anyone have objections to tagging all of these branches with a new
> prefix (maybe "legacy-ceph-wip-*") and deleting them? I don't think any
> of them are under active development at this point, so I don't think we
> need to retain them as branches.
>
> I'll give it a week or so and then do that unless anyone has objections.

I went ahead and removed those that got merged in one way or another
and renamed the rest to historic/<name>.  We have had a couple of
branches under historic "directory" for many years, so I chose to keep
these as branches.

Jenkins has been updated, any "wip-*" branch will now trigger a build.

Thanks,

                Ilya
