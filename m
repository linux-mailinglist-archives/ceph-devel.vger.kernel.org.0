Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 130EA2DC88
	for <lists+ceph-devel@lfdr.de>; Wed, 29 May 2019 14:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfE2MQQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 May 2019 08:16:16 -0400
Received: from mail-qt1-f169.google.com ([209.85.160.169]:38274 "EHLO
        mail-qt1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfE2MQQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 May 2019 08:16:16 -0400
Received: by mail-qt1-f169.google.com with SMTP id l3so2210889qtj.5
        for <ceph-devel@vger.kernel.org>; Wed, 29 May 2019 05:16:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9qyiSNEFlI5j1QHYRdP9dd1izy+WJINDBq0u0WZDhnA=;
        b=Xp/xeEJR1rYGk0ewd4akY8ZdggETRtz/PFJaYtBjdUGVqX9rbvznOuCoMo7LG4bC95
         gaPRbedgy363gcuYVDsgPta2A+vmIrJmdPvWhrNFWd2svFhCbpvmhCpDVXbeMmI2rrng
         pIdhpFnHnDgix4xBIA+DQzLBkwUk9SRl9nLNPM88n7t/NiZFJCyqFdisUGWVUHVDHwz1
         8yxaiZwr26r5+1XS2LIj91HxzTBXuBA3xLIpnbaFgnTvf9ivds/8qGNwP6NwBSVvNzmF
         nPdL7Qz8/2d1Y8+I4T2018aY0sYJeJ9LtX/ZA2y4r1xLDRauBw8mFsBDG7XeiMTg/T6J
         xJAw==
X-Gm-Message-State: APjAAAWsMSui6HoNx/t7N/QBx6jBpFvo2yhtnrRTnr9299MMOpUJC6tR
        6X9SPZgL9mEIJ2j79oolHQCG8DJLOXCBcgX4A3D4RA==
X-Google-Smtp-Source: APXvYqyp8yqZ6EnqbTR+2n8dXO/GsszOF9PTf+Q/OHA/sdF3YYfcAgfFVMqZtrT1DKlpxBg7bkExsvb2+YikDoCw0GQ=
X-Received: by 2002:a0c:b621:: with SMTP id f33mr69819459qve.199.1559132174062;
 Wed, 29 May 2019 05:16:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAMMFjmF1SP9JnyeuqCtsS9KJKRO-1R+E+NkzO-kj6+pn=chfzw@mail.gmail.com>
In-Reply-To: <CAMMFjmF1SP9JnyeuqCtsS9KJKRO-1R+E+NkzO-kj6+pn=chfzw@mail.gmail.com>
From:   Alfredo Deza <adeza@redhat.com>
Date:   Wed, 29 May 2019 08:16:02 -0400
Message-ID: <CAC-Np1wR4ik58P=UPLuuBxhqbG_REx1UFp4mDPNdBiNQFW9W_g@mail.gmail.com>
Subject: Re: 13.2.6 QE Mimic validation status
To:     Yuri Weinstein <yweinste@redhat.com>
Cc:     Sage Weil <sweil@redhat.com>, "Durgin, Josh" <jdurgin@redhat.com>,
        "Dillaman, Jason" <dillaman@redhat.com>,
        "Sadeh-Weinraub, Yehuda" <yehuda@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        "Development, Ceph" <ceph-devel@vger.kernel.org>,
        "Lekshmanan, Abhishek" <abhishek.lekshmanan@gmail.com>,
        Nathan Cutler <ncutler@suse.cz>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        ceph-qe-team <ceph-qe-team@redhat.com>,
        Andrew Schoen <aschoen@redhat.com>, ceph-qa <ceph-qa@ceph.com>,
        Matt Benjamin <mbenjamin@redhat.com>,
        Sebastien Han <shan@redhat.com>,
        Brad Hubbard <bhubbard@redhat.com>,
        Venky Shankar <vshankar@redhat.com>,
        Neha Ojha <nojha@redhat.com>,
        David Galloway <dgallowa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, May 23, 2019 at 4:00 PM Yuri Weinstein <yweinste@redhat.com> wrote:
>
> Details of this release summarized here:
>
> http://tracker.ceph.com/issues/39718#note-2
>
> rados - FAILED, known, Neha approved?
> rgw - Casey approved?
> rbd - Jason approved?
> fs - Patrick, Venky approved?
> kcephfs - Patrick, Venky approved?
> multimds - Patrick, Venky approved? (still running)
> krbd - Ilya, Jason approved?
> ceph-deploy - Sage, Vasu approved?  See SELinux denials, David pls FYI
> ceph-disk - PASSED
> upgrade/client-upgrade-jewel - PASSED
> upgrade/client-upgrade-luminous - PASSED
> upgrade/luminous-x (mimic) - PASSED
> upgrade/mimic-p2p - tests needs fixing
> powercycle - PASSED, Neha FYI
> ceph-ansible - PASSED
> ceph-volume - FAILED, Alfredo pls rerun

APPROVED. The failures are due to a configuration error, all nightly
mimic runs are passing. Filed http://tracker.ceph.com/issues/40062 to
fix the config problem.

>
> Please review results and reply/comment.
>
> PS:  Abhishek, Nathan I will back in the office next Tuesday.
>
> Thx
> YuriW
