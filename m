Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1632CFDD
	for <lists+ceph-devel@lfdr.de>; Tue, 28 May 2019 21:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfE1T7H (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 May 2019 15:59:07 -0400
Received: from mail-pl1-f178.google.com ([209.85.214.178]:46356 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbfE1T7G (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 28 May 2019 15:59:06 -0400
Received: by mail-pl1-f178.google.com with SMTP id bb3so1161584plb.13
        for <ceph-devel@vger.kernel.org>; Tue, 28 May 2019 12:59:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=7GBPe47nQtVFzwDMDZv0DY6UlWgCJcUlAJN9tLv8p/Q=;
        b=hYPJx0AdbwsitBT2HyDHkVWcGv8yd/PdruqqBe6H8lCcojWyDgnEW3W5R1kdOO05ui
         catOLWU1k+bzQzkzw33a7w5Z/WgPwxyi1UBMMjQm3OGtbPO5ZCa7IVZf5D+pZgHtO6lW
         aGmMEVVCKxsNcWqvHL8gcssVvkF134BdjxCylNM870s8pidrqb89zGGZTQSPqTBYin4h
         hWwIQAwV6nzJ4c3GoQvKWH+A/wNpjU3nCbtPg7hoA7qjv8zTr43rX3LkAUvy8fxut5YT
         w+gXCkiaIYvCDqpEibLbgOXz+bpQj/1506Fqs7m5PSo69vI0NYk8gIyBGpwJyvaqtKvt
         hjNA==
X-Gm-Message-State: APjAAAXhyxaiXqYNwRhaO6BlPa6EI4Fq6HCAN1pbEccaIqYmnTSSacL/
        2YbxmoN7hFGsGMGrtIraSuZ402hd9vbB71ZaLJoqng==
X-Google-Smtp-Source: APXvYqwUKXks9DNCqLnDwa5eRv0/bAaFg7avTgKdEkBP21NrB7SE/MDk8TffgevkI4Qk8eLiYbNq5DTLjKNZtNzqtYQ=
X-Received: by 2002:a17:902:9a83:: with SMTP id w3mr11901196plp.184.1559073545875;
 Tue, 28 May 2019 12:59:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAMMFjmF1SP9JnyeuqCtsS9KJKRO-1R+E+NkzO-kj6+pn=chfzw@mail.gmail.com>
In-Reply-To: <CAMMFjmF1SP9JnyeuqCtsS9KJKRO-1R+E+NkzO-kj6+pn=chfzw@mail.gmail.com>
From:   Yuri Weinstein <yweinste@redhat.com>
Date:   Tue, 28 May 2019 12:58:54 -0700
Message-ID: <CAMMFjmE9RpPLXUAz-ZhiLeoy5UDGxkGjuo2a5ovDO9May6X3kg@mail.gmail.com>
Subject: Re: 13.2.6 QE Mimic validation status
To:     Sage Weil <sweil@redhat.com>, "Durgin, Josh" <jdurgin@redhat.com>,
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

Pls review/approve/reply, so we can release 13.2.6 this week!

On Thu, May 23, 2019 at 1:00 PM Yuri Weinstein <yweinste@redhat.com> wrote:
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
>
> Please review results and reply/comment.
>
> PS:  Abhishek, Nathan I will back in the office next Tuesday.
>
> Thx
> YuriW
