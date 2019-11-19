Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBAF91027B3
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2019 16:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbfKSPJ4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Nov 2019 10:09:56 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:34842 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfKSPJ4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 Nov 2019 10:09:56 -0500
Received: by mail-io1-f66.google.com with SMTP id x21so23595910ior.2
        for <ceph-devel@vger.kernel.org>; Tue, 19 Nov 2019 07:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S+ew+26giqg5R2A12lhI717EI/IQVJU83AEqk0GL6Hw=;
        b=NWWNoMt2lfr1Nv+nyl+HmALyoOHLTXtb8q9bP7Ph6oITQAc7bhg5LCxRDGBTSXStwo
         s9x03Y70xXb1GLljEjSmwV0dBxsIhNHox07wGxt9gg8f3satCsXo61VjkgoTQiZIABX2
         aZ0nm/TDs9buTztB/uMuyjQ/cdLA1Ly368h6hYpdhPkO3t0uKYXU7qhvwmtZ90ZbM4CH
         8zL8YpyeLWSbWXIKd7fIxfgfvZBL0pHvcgz56pN5QUzXTjGcN93Hb5ametm5EC6bE7+5
         chtBJWXYxPgZZ6r1kjKTg4sKRDYnz3dJ12nQJX62O+al5Ajjci6h5/+iF8SVbetPHOJ0
         mMiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S+ew+26giqg5R2A12lhI717EI/IQVJU83AEqk0GL6Hw=;
        b=e5dU9FIKOzSmh1mhXCMMk26ihs6UjCrDG2Lo7SWw3f9uiVeEoK37rFrBOkCcf/UNAK
         tNfy6bXBGhvY5/nGJji8PR2gxYQpS2wXnEp73S1iYjMpaOuMC/KwMyUaM0fzjqAfR7tc
         qgRhd06fyGKVwVdaWjn01ze8GaCIzin/M1NZ89nL8KDhkquql1imAx1Quu7D3gUM/ht4
         nvrHRjuO3DKPYI14dNFZ1ho7lBa+EzqnHkidZMZiQK4skSfaCDaB/As2a9oIaHBF6SM9
         iCT20RMcXTpKJnDGyOkGutOR/gy+HTxrDOwrLkTyH/aGV/euVoiZGtjr+TfWDasWlfeN
         puAA==
X-Gm-Message-State: APjAAAVxRCHWjNGxd0fAOLWz52vwE4MSzg9cUNKdVFT6rD0vHn8AZ3Ds
        WJXz+5DPBkXVttfeeurZxMv3HETtkkoOa5jvnEycvCvK
X-Google-Smtp-Source: APXvYqzQ6FopesIxbmuHl40iGPoCWlhoTFlziaSrLNltIog54nEGz6yTGwMc0qi6SGnhLnXhQCYF/bAJGjUn/DS/V9s=
X-Received: by 2002:a6b:ba04:: with SMTP id k4mr19665265iof.131.1574176195471;
 Tue, 19 Nov 2019 07:09:55 -0800 (PST)
MIME-Version: 1.0
References: <20191118133816.3963-1-idryomov@gmail.com> <5DD3ACD6.6040009@easystack.cn>
 <CAOi1vP8xERUXtoh7sGUZDR6kRMKBVYx_6uofzA855OPR3Ar61A@mail.gmail.com> <5DD3DBF8.2010805@easystack.cn>
In-Reply-To: <5DD3DBF8.2010805@easystack.cn>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 19 Nov 2019 16:10:27 +0100
Message-ID: <CAOi1vP_o6prR7N7Or9tyBFybGM3bddkD+1+vTatEdHCdKdeOUA@mail.gmail.com>
Subject: Re: [PATCH 0/9] wip-krbd-readonly
To:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Jason Dillaman <jdillama@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Nov 19, 2019 at 1:11 PM Dongsheng Yang
<dongsheng.yang@easystack.cn> wrote:
>
>
>
> On 11/19/2019 07:59 PM, Ilya Dryomov wrote:
> > On Tue, Nov 19, 2019 at 9:50 AM Dongsheng Yang
> > <dongsheng.yang@easystack.cn> wrote:
> >>
> >> Hi Ilya,
> >>
> >> On 11/18/2019 09:38 PM, Ilya Dryomov wrote:
> >>> Hello,
> >>>
> >>> This series makes read-only mappings compatible with read-only caps:
> >>> we no longer establish a watch,
> >> Although this is true in userspace librbd, I think that's wired: when
> >> there is someone is reading this image, it can be removed. And the
> >> reader will get all zero for later reads.
> >>
> >> What about register a watcher but always ack for notifications? Then
> >> we can prevent removing from image being reading.
> > We can't register a watch because it is a write operation on the OSD
> > and we want read-only mappings to be usable with read-only OSD caps:
> >
> >    $ ceph auth add client.ro ... osd 'profile rbd-read-only'
> >    $ sudo rbd map --user ro -o ro ..
> >
> > Further, while returning zeros if an image or a snapshot is removed is
> > bad, a watch isn't a good solution.  It can be lost, and even when it's
> > there it's still racy.  See the description of patch 7
>
>
> Right, it's not that easy. Maybe we need another series patches to
> improve it.

Yeah, just watching a header as it is is not going to do it.

Thanks for the review!

                Ilya
