Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62992A488E
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Nov 2020 15:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgKCOr3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 3 Nov 2020 09:47:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbgKCOpQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 3 Nov 2020 09:45:16 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD61CC0613D1
        for <ceph-devel@vger.kernel.org>; Tue,  3 Nov 2020 06:45:16 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id g15so1583271ilc.9
        for <ceph-devel@vger.kernel.org>; Tue, 03 Nov 2020 06:45:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CZ1C1bhGHbLT2J0O03UaNSEHgrUbANBve1dvQ3z9B9o=;
        b=NNq1zBZp79psiUK8zluCX0Yyc7PH9xO3Et4qPyp2FrjQz7QxFDvN3pyRY75kwFaFwN
         jz1S2mxkK4aaMjTzMI0bH1xEDwRXiFH6w0hSBwoHZZT7GvyePuskIevFmDcyFDmcuAsd
         ds+6TVSac2RQFwWGgXVbbJzWL9+f1FOGnceczySA5+zkxhlrOKd4dvgsbb/NImSriRcZ
         OuVS7kqaUUmF4xwYF+e44Y1OAo9bbma2LoHIkkief2oR/FaB3TRAMoD/Z4GnVXh1ja8W
         txU9mDMlazeW/QN77y0vzR0cNUEPqfu6C6ViDihRea3MBmAwc1SY5h4lTIt1w0Em3gjb
         oRfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CZ1C1bhGHbLT2J0O03UaNSEHgrUbANBve1dvQ3z9B9o=;
        b=giSsKcZZQMsbIOaka/pXWy61u8mH7Z6ohexMuxWrD+tGtbpiSFY/tVxwNDnAS6jph0
         K99Bt1O7cuxdGOeuQqF84lBKkSGreLvIISOJWb32FVEQ7zurl15CQ3LgWTqh4PxQ+Nlb
         d/RxGNMYfP3zyW1+ExBU2oe2NaWTI9JPfq5xRVO1OiT+tJFMNiseC56mYyx4nOjIwrjh
         F4iZV1pVstIwT4VZ8PRVSJfpAz0rFxoHXM/pgybu1z3Nfa0Fug+l2ouGDRni5jR7fXNC
         QX3hSs77e9oxOqNo6FBVkP/litPZ+y+jj5xC1uPGtVHh8kU4i8+mwW/Cdt6Af2hpe/ir
         2GJA==
X-Gm-Message-State: AOAM533SCPbkcUr6N4//lW5LajKzF83ef4jgVBm0VfRFLuPnDT7RHNWj
        Na0+8ArB4DkNFoBIFkc8Q/r6IAwgrtvn4Dux8W4=
X-Google-Smtp-Source: ABdhPJxLTM6xGckyhYhsvYhpVP2b71x4JKw+/iv1iBB6wolnhdBxNDFGUp+akWvtFesF8UXzatygDNmH1r7KvsNDB4c=
X-Received: by 2002:a92:c529:: with SMTP id m9mr14655762ili.195.1604414715103;
 Tue, 03 Nov 2020 06:45:15 -0800 (PST)
MIME-Version: 1.0
References: <b4726535239f4b0e723d3f45da3a7fcf1412c943.camel@redhat.com> <054c62ca910759e6f49d483363b2177351974663.camel@redhat.com>
In-Reply-To: <054c62ca910759e6f49d483363b2177351974663.camel@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 3 Nov 2020 22:45:04 +0800
Message-ID: <CAAM7YAmU1FQkFjehQcjt16BGSbtd7E1mgf5rkQYss5ZQXKZLZQ@mail.gmail.com>
Subject: Re: cephfs inode size handling and inode_drop field in struct MetaRequest
To:     Jeff Layton <jlayton@redhat.com>
Cc:     dev <dev@ceph.io>, Ceph Development <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Oct 30, 2020 at 12:53 AM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Thu, 2020-10-29 at 11:19 -0400, Jeff Layton wrote:
> > I'm working on a F_SETLEASE implementation for kcephfs, and am hitting a
> > deadlock of sorts, due to a truncate triggering a cap revoke at an
> > inopportune time.
> >
> > The issue is that truncates to a smaller size are always done via
> > synchronous call to the MDS, whereas a truncate larger does not if Fx
> > caps are held. That synchronous call causes the MDS to issue the client
> > a cap revoke for caps that the lease holds references on (Frw, in
> > particular).
> >
> > The client code has been this way since the inception and I haven't been
> > able to locate any rationale for it. Some questions about this:
> >
> > 1) Why doesn't the client ever buffer a truncate to smaller size? It
> > seems like that is something that could be done without a synchronous
> > MDS call if we hold Fx caps.
> >

because we need to increate truncate_seq. truncate_seq makes OSD drop/adjust
write operation that were sent before the truncate.

> > 2) The client setattr implementations set inode_drop values in the
> > MetaRequest, but as far as I can tell, those values end up being ignored
> > by the MDS. What purpose does inode_drop actually serve? Is this field
> > vestigial?
>
>
> I think I answered the second question myself. It _is_ potentially used
> to encoded a cap release into the call. That's not happening here
> because of the extra references held by the lease. I think I see a
> couple of potential fixes for that problem.
>
> I think the first question is still valid though.
> --
> Jeff Layton <jlayton@redhat.com>
>
