Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDF4E315AC
	for <lists+ceph-devel@lfdr.de>; Fri, 31 May 2019 21:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbfEaTxq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 31 May 2019 15:53:46 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:33311 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727343AbfEaTxp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 31 May 2019 15:53:45 -0400
Received: by mail-pf1-f175.google.com with SMTP id x10so1702201pfi.0
        for <ceph-devel@vger.kernel.org>; Fri, 31 May 2019 12:53:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dPDJ5mJ1xYqsixTbbuRCT0xAgniCgTqxChZPLq7mYVo=;
        b=Wp2/91HnFd9Sf/vY9sZMyZ1S5sD3rP7/l5EpYV/fkCmY7Wpbvdw1oWA0PP8MZQpq8j
         oKR5Tsy7/Lva2Jwj+BrkiT7fZaU+jvrB/eYATz9OXVJToDr+o9StN0s0SJixBlWrp7DU
         UK1V1YeV1lgUfSkYIiYZAi+itNYXG5dkA5PmNMeq4DpwCxFgwDX1rPmHwmuLPiA08WjI
         U5eDl4GwURqkK0mfGU/Yxg3rJdPGxuBfcW3GmjL6Wo6D2rDX1A8KG5/9VW1pD33xitPT
         mtAx2+RVRx6mnnbTQxhuFuAJoqEyHmSCSUEOAUT1oGPYHbgWr+Pa9W4DgBpKfcDBTUkh
         88Kg==
X-Gm-Message-State: APjAAAUBJG0dnFLrhH+A7HqGKZwv2Dw1t+LjhKe2te65G1lEVr3m4ByR
        GpEXjX3gcXUvLb43luE8fpd0RpQBxe/ip3ErG1Ncbw==
X-Google-Smtp-Source: APXvYqxmJT4yrTHbSo8MBx+B865vEhn9V66240YJnl99wd8rN5M7y3qj4Cw6EAWD6tp1rEi9BLs0KgvKxdxyIHM1ZCI=
X-Received: by 2002:a17:90a:17ca:: with SMTP id q68mr11913781pja.104.1559332425214;
 Fri, 31 May 2019 12:53:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAMMFjmF1SP9JnyeuqCtsS9KJKRO-1R+E+NkzO-kj6+pn=chfzw@mail.gmail.com>
 <CAC-Np1wR4ik58P=UPLuuBxhqbG_REx1UFp4mDPNdBiNQFW9W_g@mail.gmail.com>
 <CAMMFjmGro96-bhMOe2KGYjZLAu-6RrNKAvOom+wP3ovg_+ss7Q@mail.gmail.com> <fc64e04b-bae8-8e3c-a561-ab3d0d1489a3@redhat.com>
In-Reply-To: <fc64e04b-bae8-8e3c-a561-ab3d0d1489a3@redhat.com>
From:   Yuri Weinstein <yweinste@redhat.com>
Date:   Fri, 31 May 2019 12:53:34 -0700
Message-ID: <CAMMFjmFOGru6K3O00D9a+==VwZV4qBZKHHyjHsdCRm+CDi9jQg@mail.gmail.com>
Subject: Re: 13.2.6 QE Mimic validation status
To:     Josh Durgin <jdurgin@redhat.com>
Cc:     Alfredo Deza <adeza@redhat.com>, Sage Weil <sweil@redhat.com>,
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

All runs were approved.
See only ceph-deploy that sees not bad, Sage.

Also note that 3 commits were merged on top (related to upgrade/mimic-p2p fixes)

I did not rerun all suites on the latest SHA1, so if this is a problem
pls speak up.

Otherwise, Sage, Abhishek, Nathan, David ready for publishing.

Thx
YuriW
