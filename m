Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED062D168
	for <lists+ceph-devel@lfdr.de>; Wed, 29 May 2019 00:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfE1WUR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 May 2019 18:20:17 -0400
Received: from mail-ed1-f49.google.com ([209.85.208.49]:40349 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbfE1WUR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 28 May 2019 18:20:17 -0400
Received: by mail-ed1-f49.google.com with SMTP id s19so320981edq.7
        for <ceph-devel@vger.kernel.org>; Tue, 28 May 2019 15:20:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=YrtqEAQOLojMqu0THoo5QCbSzXDFKXCvlWqwngikjqA=;
        b=BcjtX7qOgVW+9gMIYCu8a+zrRdxp6l743N7+wtcFiZDB0+qIA+2fzSlJ+XASAIkP9a
         9WJH1o8YinHNexF3+Eez4EVIV4jjuBcMf3aIGWipqrjy3DasLkMQlXTi7vhZi3LSX+et
         XXOzHtXp6F/S/BIfLW3Z1e28Q1ZN02+1CzdD8Yy0Ul9DTuqVRfQLbVKgBHL9O9O8q8tv
         OkIhwxnFH1TXdge5Rr2nuFf5yEsCjqaHMYRfa/mG7taLPnWJGXdeHNuj8Z9cX5UjBe1f
         /PFj1/+ytPrBIUCaVk4JHCzbWIHOofZHLb77kh88XFG5gRRqlex+HXPi5fytiDQ8+HGL
         HIRg==
X-Gm-Message-State: APjAAAW0925b4gKz9Lu7T6/RDHOM4RvHNT+UF/FXngw+8YL5wIwpOc5I
        0IZdrZdrb2YgPG5zY1a/yrPh4tXa9AkUSFVmP+LkRA==
X-Google-Smtp-Source: APXvYqzSmuUgmlT7Z6nIHAcRcV2ni4uggxgTtTnJf85RoxK0F+yI5KeMtzRVTUFz4egZ4CbNqM1pD6uHk392ZKN82xQ=
X-Received: by 2002:a50:bb24:: with SMTP id y33mr131124428ede.116.1559082016188;
 Tue, 28 May 2019 15:20:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAMMFjmF1SP9JnyeuqCtsS9KJKRO-1R+E+NkzO-kj6+pn=chfzw@mail.gmail.com>
In-Reply-To: <CAMMFjmF1SP9JnyeuqCtsS9KJKRO-1R+E+NkzO-kj6+pn=chfzw@mail.gmail.com>
Reply-To: dillaman@redhat.com
From:   Jason Dillaman <jdillama@redhat.com>
Date:   Tue, 28 May 2019 18:20:05 -0400
Message-ID: <CA+aFP1DuB4Xta2uafT2TRLZOdGZp4-2ORwVf7ThM=uGJsL0yNQ@mail.gmail.com>
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

On Thu, May 23, 2019 at 4:00 PM Yuri Weinstein <yweinste@redhat.com> wrote:
>
> Details of this release summarized here:
>
> http://tracker.ceph.com/issues/39718#note-2
>
> rados - FAILED, known, Neha approved?
> rgw - Casey approved?
> rbd - Jason approved?

Approved.

> fs - Patrick, Venky approved?
> kcephfs - Patrick, Venky approved?
> multimds - Patrick, Venky approved? (still running)
> krbd - Ilya, Jason approved?

Defer to Ilya.

> ceph-deploy - Sage, Vasu approved?  See SELinux denials, David pls FYI
> ceph-disk - PASSED
> upgrade/client-upgrade-jewel - PASSED
> upgrade/client-upgrade-luminous - PASSED
> upgrade/luminous-x (mimic) - PASSED
> upgrade/mimic-p2p - tests needs fixing
> powercycle - PASSED, Neha FYI
> ceph-ansible - PASSED
> ceph-volume - FAILED, Alfredo pls rerun
>
> Please review results and reply/comment.
>
> PS:  Abhishek, Nathan I will back in the office next Tuesday.
>
> Thx
> YuriW



-- 
Jason
