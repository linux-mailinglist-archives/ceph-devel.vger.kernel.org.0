Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1558E164ED2
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Feb 2020 20:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgBSTWv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Feb 2020 14:22:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56827 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726672AbgBSTWv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 19 Feb 2020 14:22:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582140170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UgCQOE/lO0nkezEI9WMe0bqFFayHqEycLguICJYxj/0=;
        b=ER4MIlx6fEVD/E3CaUkFIhD3O6vi/lQ9K3AULXXx/cUEr77li20/2WHpaTE/Ilf6AzM6ep
        et897606hssKpd2sGzVonmFuOGLmtI4iyA4JDF8fTtl01WUcOsSPHQoIOSoLq62Gc39OGc
        kcRF0+BT8xVaOI8iGWaNjZXhin63iSI=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-ZCusE-70MWKKsCzQU7e-VA-1; Wed, 19 Feb 2020 14:22:43 -0500
X-MC-Unique: ZCusE-70MWKKsCzQU7e-VA-1
Received: by mail-io1-f69.google.com with SMTP id n26so896929ioj.1
        for <ceph-devel@vger.kernel.org>; Wed, 19 Feb 2020 11:22:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UgCQOE/lO0nkezEI9WMe0bqFFayHqEycLguICJYxj/0=;
        b=D011/hJ9T9k5HKzoRcPM2s8BJ8JexgdLFVaSpO6UNQNsdFzTw3MldxXjB7hcJn4ZgI
         VdnNphsIiLnJI7N0wqzOif4oIiyEL049cQ7M1EiCdjUfV+J8TbBrBwATe91qfAdWlR2r
         K8Cbk6T1buD0BZA1YW75X0GT+O7Jn5yn/q1+0o10cnI09ztlwk3pj/OgO369g31pqdQd
         i50Ljqr75w6lRFDmQCBZEP0esc2ctusT5h2GaQ15HDKBcjHsofZqd1J+L1YZ4RdvD2gY
         PmHSixFIjokOZ9ZCP8DHU8a0dyVLQPcXmXLve8+1CmYc+JrWN/ftRMg5Hsm0JL88ZQu6
         vhKQ==
X-Gm-Message-State: APjAAAX2cdc2/aGxXHqGa72sQ9kC+lu9iumEuCPrDkU6Zvwtboldd9og
        Py95121wCV/4P3FyOJpPvEXNYvrsX1GV/qX2mbCsx5zcXgmIExs2T0l6Vz0In1M2KLh8QlWhG/w
        pFjAk5OWDDXrXf/qTFpu/pq6cf7/HtVLUDroSDg==
X-Received: by 2002:a92:b744:: with SMTP id c4mr23919792ilm.34.1582140163060;
        Wed, 19 Feb 2020 11:22:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqxRgLz8R2qKDBRpk9VVBYIqfCrpUTWXcJrzUnWH1hyixHdrELU4x896EovLAIrjSHjgCw8WkyL1hbCd1thclVo=
X-Received: by 2002:a92:b744:: with SMTP id c4mr23919777ilm.34.1582140162810;
 Wed, 19 Feb 2020 11:22:42 -0800 (PST)
MIME-Version: 1.0
References: <20200216064945.61726-1-xiubli@redhat.com> <78ff80dd12d497be7a6606a60973f7e2d864e910.camel@kernel.org>
 <36e1f3a9-1688-9eb0-27d7-351a12bca85a@redhat.com> <4a4cfe2a5fc1de6f73fa3f557921c1ad5802add6.camel@kernel.org>
 <CAOi1vP_yGJGqkY+QLdQoruJrS3gawEC-_NqDnpucCWfXOHL-aQ@mail.gmail.com>
In-Reply-To: <CAOi1vP_yGJGqkY+QLdQoruJrS3gawEC-_NqDnpucCWfXOHL-aQ@mail.gmail.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Wed, 19 Feb 2020 11:22:16 -0800
Message-ID: <CA+2bHPZmjvbtFBNzviR6uYsM=bF92qC-Xkgm2uucBe6KJHjJbg@mail.gmail.com>
Subject: Re: [PATCH] ceph: add halt mount option support
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        Sage Weil <sage@redhat.com>, "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Feb 18, 2020 at 6:59 AM Ilya Dryomov <idryomov@gmail.com> wrote:
> > Yeah, I've mostly done this using DROP rules when I needed to test things.
> > But, I think I was probably just guilty of speculating out loud here.
>
> I'm not sure what exactly Xiubo meant by "fulfilling" iptables rules
> in libceph, but I will say that any kind of iptables manipulation from
> within libceph is probably out of the question.

I think we're getting confused about two thoughts on iptables: (1) to
use iptables to effectively partition the mount instead of this new
halt option; (2) use iptables in concert with halt to prevent FIN
packets from being sent when the sockets are closed. I think we all
agree (2) is not going to happen.

> > I think doing this by just closing down the sockets is probably fine. I
> > wouldn't pursue anything relating to to iptables here, unless we have
> > some larger reason to go that route.
>
> IMO investing into a set of iptables and tc helpers for teuthology
> makes a _lot_ of sense.  It isn't exactly the same as a cable pull,
> but it's probably the next best thing.  First, it will be external to
> the system under test.  Second, it can be made selective -- you can
> cut a single session or all of them, simulate packet loss and latency
> issues, etc.  Third, it can be used for recovery and failover/fencing
> testing -- what happens when these packets get delivered two minutes
> later?  None of this is possible with something that just attempts to
> wedge the mount and acts as a point of no return.

This sounds attractive but it does require each mount to have its own
IP address? Or are there options? Maybe the kernel driver could mark
the connection with a mount ID we could do filtering on it? From a
quick Google, maybe [1] could be used for this purpose. I wonder
however if the kernel driver would have to do that marking of the
connection... and then we have iptables dependencies in the driver
again which we don't want to do.

From my perspective, this halt patch looks pretty simple and doesn't
appear to be a huge maintenance burden. Is it really so objectionable?

[1] https://home.regit.org/netfilter-en/netfilter-connmark/


-- 
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

