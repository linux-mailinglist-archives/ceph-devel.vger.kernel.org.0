Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D71FD2D84B
	for <lists+ceph-devel@lfdr.de>; Wed, 29 May 2019 10:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfE2I4B (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 May 2019 04:56:01 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:36991 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbfE2Iz7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 May 2019 04:55:59 -0400
Received: by mail-it1-f193.google.com with SMTP id s16so2298321ita.2
        for <ceph-devel@vger.kernel.org>; Wed, 29 May 2019 01:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CuENksJM/C+RlhueZmhcah2BD/oid1GAjRYmEVCgOG0=;
        b=VULl04FyDu1HptiELn+1pukoTDkiGxmCJ8jMXymWKmimF/FAtpIrFlki2r4itM6cSD
         hYnmOtuiaCCOpECZg0XqpkpJ539kZvzirokPGvK/FXjUZLfe5NvCNXM7JzWAO56wbalX
         CTMdFfhEi0Pj9/KN8CWtPmc8f0BmvMXL0bvtcWRJyo6UwkVoTO6P4xquDeNy6/b2TQbP
         ulY7JyOgwRoof37YB98fDNs4ZWOiZEhF1WANyxdNx1cLZ4TYkA9aSY8wunUL3Aw9EGRN
         e4TEtNmTT/5kEF/+zSXopQ68O7DS1TvlIayIl/vwrVLu0eUgT1ZaHhfjEI1irAVFxOw7
         otQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CuENksJM/C+RlhueZmhcah2BD/oid1GAjRYmEVCgOG0=;
        b=aWjdy5eZevmWyvgPZBr+2LkQ59peESWED/CFfg8OFFHVaJqjtufEuOhJS8XY6x1avi
         dcgTT3bzKnO1/Y7wlVL/0ZASpjtwMhfgv5WGsTIu7TvXN/WDa05oELr2710xERJ3QQl+
         7R6sDo4bGx7ik/ssqCRktid43clu7BS4S+KcKSy9O4afzyPYFMibNF0JlIgyJpa25PNt
         6QT69MfvcRStEIAZwycJZehYFBX+zy74q4H3W/pfenPTDgpFZUrn9G2iAJ36ynXfldyx
         8RqoIm1wMuUPoJ9mqKLoDISO2jASekBNBmugvbH7ZlDN9hJsfxJ6MZmOjDb3aWZlQbAs
         4nEg==
X-Gm-Message-State: APjAAAVYsOAoQJoVfepHw+KhBYZe4JzVUyg2hAcKoDNp1NMxSiUj2SH4
        TMz0bZA3BexE7Hq70EsOsy6lPAb7+B1AKvmtnz4=
X-Google-Smtp-Source: APXvYqxkD4C665++7zRNGP5D3qGdfiJaxS1V9aTS+ykQ+s8pQXIfUUs0iDFmzpYOgrw8kAUdB4YdaZ1s2OcoTgC8fFQ=
X-Received: by 2002:a02:cd82:: with SMTP id l2mr6156544jap.96.1559120158805;
 Wed, 29 May 2019 01:55:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAMMFjmF1SP9JnyeuqCtsS9KJKRO-1R+E+NkzO-kj6+pn=chfzw@mail.gmail.com>
 <CA+aFP1DuB4Xta2uafT2TRLZOdGZp4-2ORwVf7ThM=uGJsL0yNQ@mail.gmail.com>
In-Reply-To: <CA+aFP1DuB4Xta2uafT2TRLZOdGZp4-2ORwVf7ThM=uGJsL0yNQ@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 29 May 2019 10:55:59 +0200
Message-ID: <CAOi1vP86ayYgOSWfyUZPkg4meAYKxhobG3pEYgkQPU50B6mPjQ@mail.gmail.com>
Subject: Re: 13.2.6 QE Mimic validation status
To:     Jason Dillaman <dillaman@redhat.com>
Cc:     Yuri Weinstein <yweinste@redhat.com>, Sage Weil <sweil@redhat.com>,
        "Durgin, Josh" <jdurgin@redhat.com>,
        "Sadeh-Weinraub, Yehuda" <yehuda@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        "Development, Ceph" <ceph-devel@vger.kernel.org>,
        "Lekshmanan, Abhishek" <abhishek.lekshmanan@gmail.com>,
        Nathan Cutler <ncutler@suse.cz>,
        Jeff Layton <jlayton@redhat.com>,
        ceph-qe-team <ceph-qe-team@redhat.com>,
        "Deza, Alfredo" <adeza@redhat.com>,
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

On Wed, May 29, 2019 at 12:20 AM Jason Dillaman <jdillama@redhat.com> wrote:
>
> On Thu, May 23, 2019 at 4:00 PM Yuri Weinstein <yweinste@redhat.com> wrote:
> >
> > Details of this release summarized here:
> >
> > http://tracker.ceph.com/issues/39718#note-2
> >
> > rados - FAILED, known, Neha approved?
> > rgw - Casey approved?
> > rbd - Jason approved?
>
> Approved.
>
> > fs - Patrick, Venky approved?
> > kcephfs - Patrick, Venky approved?
> > multimds - Patrick, Venky approved? (still running)
> > krbd - Ilya, Jason approved?
>
> Defer to Ilya.

Approved.

(I checked these runs last week, but didn't reply because the tracker
note made it look like it had already been approved ("approved" in blue
with no question mark or anything else of that sort...)

Thanks,

                Ilya
