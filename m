Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11DD515F771
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Feb 2020 21:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389171AbgBNUHR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 Feb 2020 15:07:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28848 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388578AbgBNUHR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 14 Feb 2020 15:07:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581710836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7yDyKoAxNNV83R2f95mvpdsGvNk95BOGo4nN5ea/HeI=;
        b=KoBA/mS8oRtROem9XvZGS6M6icEP0dGPKn2FnaJtJSym/QFycTlbKcQWwphbHSmVDXwyAQ
        B5mSLCZy2SFR3zK42PpzDAPwPaIRITJlRPCCVOWfS7Ub5u8JJp1VgKLkwQvkpAWppVi0Ir
        BYH/9EyV1cb8VLIAR6t8xepcgDZUdeQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-eGFhDYQxNJuY0zC8i7m1Cw-1; Fri, 14 Feb 2020 15:07:14 -0500
X-MC-Unique: eGFhDYQxNJuY0zC8i7m1Cw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5207100550E;
        Fri, 14 Feb 2020 20:07:12 +0000 (UTC)
Received: from ovpn-112-14.phx2.redhat.com (ovpn-112-14.phx2.redhat.com [10.3.112.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EBDC460BF4;
        Fri, 14 Feb 2020 20:06:55 +0000 (UTC)
Date:   Fri, 14 Feb 2020 20:06:54 +0000 (UTC)
From:   Sage Weil <sweil@redhat.com>
X-X-Sender: sage@piezo.novalocal
To:     Yuri Weinstein <yweinste@redhat.com>
cc:     dev@ceph.io, "Development, Ceph" <ceph-devel@vger.kernel.org>,
        Abhishek Lekshmanan <abhishek@suse.com>,
        Nathan Cutler <ncutler@suse.cz>,
        Casey Bodley <cbodley@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Neha Ojha <nojha@redhat.com>,
        "Durgin, Josh" <jdurgin@redhat.com>,
        David Zafman <dzafman@redhat.com>,
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
Subject: Re: FYI nautilus branch is locked
In-Reply-To: <CAMMFjmGOqAoBYmmFOWFHTw9NrGQEwNLeUPmw2+5RE+LzVMsuYw@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2002142006120.18815@piezo.novalocal>
References: <CAMMFjmE4wyKcP0KkudhTu2zeZF+SswZ=kN_k-Xaq1aC6o4vWkQ@mail.gmail.com> <CAMMFjmGOqAoBYmmFOWFHTw9NrGQEwNLeUPmw2+5RE+LzVMsuYw@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Just a note, we need to sort out the mimic->nautilus upgrade failure 
before getting too far along here




On Fri, 14 Feb 2020, Yuri Weinstein wrote:

> Sorry correction again - 14.2.8
> 
> On Fri, Feb 14, 2020 at 11:30 AM Yuri Weinstein <yweinste@redhat.com> wrote:
> >
> > We are getting ready to test 14.2.9 and nautilus branch is locked for
> > merges until it's done.
> >
> > sah1 - 4d5b84085009968f557baaa4209183f1374773cd
> >
> > Nathan, Abhishek pls confirm.
> >
> > Thank you
> > YuriW
> _______________________________________________
> Dev mailing list -- dev@ceph.io
> To unsubscribe send an email to dev-leave@ceph.io
> 
> 

