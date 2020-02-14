Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E51E15EC40
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Feb 2020 18:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391765AbgBNR0E (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 Feb 2020 12:26:04 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28709 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391151AbgBNR0D (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 14 Feb 2020 12:26:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581701162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HHRjGZXDTDu7ZJHKzu7nACeb9uwk6TbUa3wEBIyYpm8=;
        b=VYITqgfx6kWNd8Bd6vO9XEpZ3oI4fbIy/1IiK/Wpy5QHbQ7ydcs09AqhevBqH9CX0/aIib
        oygFhSc8y9iE3HuDqRPFUK7SMN43GSdfMmBWdMRmqz4acU5uT1/BbUQsEiJUTUu+2sy1oi
        E6ifh/T0EM+MsvjAI6TucWjYUrXhdZc=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-O_XaihTQNeS-Z-ksoYxNDQ-1; Fri, 14 Feb 2020 12:25:58 -0500
X-MC-Unique: O_XaihTQNeS-Z-ksoYxNDQ-1
Received: by mail-qk1-f197.google.com with SMTP id 24so6634159qka.16
        for <ceph-devel@vger.kernel.org>; Fri, 14 Feb 2020 09:25:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=HHRjGZXDTDu7ZJHKzu7nACeb9uwk6TbUa3wEBIyYpm8=;
        b=HJQim686BJcaOPu7f2+JVDTYfQRKwalKxwXe78sO/XvLT2qqO4+z5+tHbnSsXTzkKW
         pk8ZuB2IakGqQ8odirn0mBkUXjc7/4S/mg6lt/uDsDg+ujqmrldpRld45BD2Bgq9QurR
         y3Ve8EpJlRxpNcxbX/Aw7HKi4ydvb7T0vwygjmbxdgnKraKCw1oSS6+7G44y6Edr8uiV
         h7DpuRx0hY5dFJAk9mtvV0o9T8NymHmCms92fJ1GKe8GOfXyq/BkEaEfvG3FuyMLUflJ
         9I/h0Uw4SA1EDyI/psaMx9/uDhdXXLmYvS5HJML56y9ZKO7AN+cou6R62ii+V9TluTTB
         sRXQ==
X-Gm-Message-State: APjAAAWwb6t/fkJYsqmCCDn5NpRYQJ95OlW7itvJkaqfVBosb3tJtBLt
        XE74sO25yLAk2SwnHWjsGH9oI73/FQJmaoaCkinr5DX2fVJp2hsQ/p1dEfqUIOYaFHcZO8fD2R4
        /fQI4USCv8zbF8Yp3CILa2/GCRXhrn87myph1mw==
X-Received: by 2002:a37:7245:: with SMTP id n66mr3840165qkc.202.1581701158420;
        Fri, 14 Feb 2020 09:25:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqy7crzeEeZd1yYtjCPeIbEnNWulSv9aD8XU8rwJJxYdJwQJlFU/z6xy+uLb0u8gF20geWxtXkl1b4WoCLGcbxg=
X-Received: by 2002:a37:7245:: with SMTP id n66mr3840118qkc.202.1581701158116;
 Fri, 14 Feb 2020 09:25:58 -0800 (PST)
MIME-Version: 1.0
References: <CAMMFjmGWrhC_gd3wY5SfqfSB6O=0Tp_QRAu0ibMTDPVrja2HSg@mail.gmail.com>
 <20200214171554.l7ibzoo64uthd2ke@jfsuselaptop>
In-Reply-To: <20200214171554.l7ibzoo64uthd2ke@jfsuselaptop>
From:   Yuri Weinstein <yweinste@redhat.com>
Date:   Fri, 14 Feb 2020 09:25:47 -0800
Message-ID: <CAMMFjmGDBQf+K5K2Zz4e6-PJS=y1YoUAEm5_X0tTUTre3EmZgA@mail.gmail.com>
Subject: Re: Readiness for 14.2.7 ?
To:     Yuri Weinstein <yweinste@redhat.com>, dev@ceph.io,
        "Development, Ceph" <ceph-devel@vger.kernel.org>,
        Abhishek Lekshmanan <abhishek@suse.com>,
        Nathan Cutler <ncutler@suse.cz>,
        Casey Bodley <cbodley@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Neha Ojha <nojha@redhat.com>,
        "Durgin, Josh" <jdurgin@redhat.com>,
        David Zafman <dzafman@redhat.com>,
        "Weil, Sage" <sweil@redhat.com>,
        Ramana Venkatesh Raja <rraja@redhat.com>,
        Tamilarasi Muthamizhan <tmuthami@redhat.com>,
        "Dillaman, Jason" <dillaman@redhat.com>,
        "Sadeh-Weinraub, Yehuda" <yehuda@redhat.com>,
        "Lekshmanan, Abhishek" <abhishek.lekshmanan@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        ceph-qe-team <ceph-qe-team@redhat.com>,
        Andrew Schoen <aschoen@redhat.com>, ceph-qa <ceph-qa@ceph.com>,
        Matt Benjamin <mbenjamin@redhat.com>,
        Sebastien Han <shan@redhat.com>,
        Brad Hubbard <bhubbard@redhat.com>,
        Venky Shankar <vshankar@redhat.com>,
        David Galloway <dgallowa@redhat.com>,
        Milind Changire <mchangir@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Thank you !

Correction  - the subject line should say 14.2.7

On Fri, Feb 14, 2020 at 9:19 AM Jan Fajerski <jfajerski@suse.com> wrote:
>
> On Mon, Feb 10, 2020 at 11:57:19AM -0800, Yuri Weinstein wrote:
> >Below is the current queue of PRs:
> >https://github.com/ceph/ceph/pulls?page=3D2&q=3Dis%3Aopen+label%3Anautil=
us-batch-1+label%3Aneeds-qa
> >
> >Most PRs are being tested.
> >Unless there are objections, we will start QE validation as soon as
> >all PRs in this queue were merged.
> >
> >Dev leads - pls add and tag all RRs that must be included.
> ceph-volume is ready, al backports are merged and tested (thank you Natha=
n!).
> >
> >Thx
> >YuriW
> >
>
> --
> Jan Fajerski
> Senior Software Engineer Enterprise Storage
> SUSE Software Solutions Germany GmbH
> Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
> (HRB 36809, AG N=C3=BCrnberg)
> Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer
>

