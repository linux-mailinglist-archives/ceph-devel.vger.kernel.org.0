Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0E9B93E0
	for <lists+ceph-devel@lfdr.de>; Fri, 20 Sep 2019 17:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391782AbfITPV5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 20 Sep 2019 11:21:57 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34716 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388486AbfITPV4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 11:21:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1568992915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NHXHQEyYDc5wqBKGv6M7zpF7u0OdBzE45mnTbhZdoMo=;
        b=Tkulaerhfb9EL98NTzjZRRY61aZB4D4aQXj819ErRQD/eEK0lDIY/YBEsfYTsX4KaNYjMx
        jzAZBASl8eBNdXbITxIMbeoRuH+5oqyKp3IwpqN3wZ3qaZyiIE0+QnChsv4TcqmM+w8dkR
        sk3BjUqZ2EpbYbhIF4wZaclIabffL18=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-oeoZ-LtIM6iYEmnYvRlujw-1; Fri, 20 Sep 2019 11:21:53 -0400
Received: by mail-qk1-f197.google.com with SMTP id s28so8440891qkm.5
        for <ceph-devel@vger.kernel.org>; Fri, 20 Sep 2019 08:21:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hx+XdpfZcn1FWBRcVraga5DiXmW+/4uuslLu6QqTBIY=;
        b=NxpOJPv+Jmuc6dwfVG8g1SoMeTF8AQ8T9huv1yGcqKceEbTZZVT1XBy7rkdJNYLE8j
         +Bvpg5aTcyrLrZyfPOrGpTME2D8aBDXLXSd/mTzb13okqpRQWxmd4ySUjnGeBNCUZKUX
         MpiwYladMy4SUK7zGUrBm2Fz7ZU+Swq6s+mlap4bbUFB0LpcUSRUsD2J4nKPRvE626Kh
         wos8wks/n+TMEfH2X2CaOEarNFXbt5JtKfSkaEz7qSVPJrsBT6JNZCz64iiapWguFjl9
         ZkD180C5RDLTpPTrmSBWnXuCE9Ycmbvdiq7f4pHk0l5qTWgIlQC/NDO284fripaGVqT4
         DyHg==
X-Gm-Message-State: APjAAAXZSXe4eeee2EOaGoelIXxf9iy+UsGOnQOVvqaXD0qgyyifwMAb
        s18LqfM+DuQPreuSFRm7IvIBqATqFU5QUNEUw6AVAA8/JHIZIBxO6p4cLUdgr2bJWBnOTrqCA2V
        hc1mqViVKb+aQQHg1LsAm+5ORpJvq9U+31XVaTQ==
X-Received: by 2002:a0c:eda2:: with SMTP id h2mr13108220qvr.190.1568992912946;
        Fri, 20 Sep 2019 08:21:52 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyX1xDU1Gyj/nqYEDbdHwSs6Zxrobx8uuw0NhkoHMN65PoXQzBX9jPCYp6megauoL3Qhd6yMFl/sAkB9BBwIlM=
X-Received: by 2002:a0c:eda2:: with SMTP id h2mr13108204qvr.190.1568992912704;
 Fri, 20 Sep 2019 08:21:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAC-Np1xa5riFgb_tZG3vFn-dcuKtyV+BSCBZV6uu8+6JRrnrWQ@mail.gmail.com>
 <alpine.DEB.2.11.1909201453051.5147@piezo.novalocal>
In-Reply-To: <alpine.DEB.2.11.1909201453051.5147@piezo.novalocal>
From:   Alfredo Deza <adeza@redhat.com>
Date:   Fri, 20 Sep 2019 11:21:41 -0400
Message-ID: <CAC-Np1ybHN212ZWbq4zceDrdsCxTTciHbQy4g2O5H0+UEvOE1g@mail.gmail.com>
Subject: Re: Set/Unset OSD 'Allows Journal'
To:     Sage Weil <sage@newdream.net>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
X-MC-Unique: oeoZ-LtIM6iYEmnYvRlujw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Sep 20, 2019 at 10:55 AM Sage Weil <sage@newdream.net> wrote:
>
> On Thu, 19 Sep 2019, Alfredo Deza wrote:
> > After deploying Ceph with ceph-deploy on Bionic, the latest luminous
> > (12.2.12) has ceph-disk creating a file for a journal - something that
> > is very surprising as I have never seen that functionality in
> > ceph-disk, without specifying any flags that might indicate a file is
> > needed.
> >
> > Using the same approach with ceph-ansible, the OSD would be created
> > with a partition (again, via ceph-disk). Same arguments and all,
> > similar to:
> >
> > ceph-disk -v prepare --cluster=3Dceph --filestore --dmcrypt /dev/sdX
> >
> > After going through all the ceph-disk output, this line got different
> > results from the ceph-deploy cluster than the ceph-ansible one:
> >
> > /usr/bin/ceph-osd --check-allows-journal -i 0 --log-file
> > /var/log/ceph/$cluster-osd-check.log --cluster ceph --setuser ceph
> > --setgroup ceph
>
> This will always be true for filestore and always false for bluestore.
> Perhaps this is a subtle change due to the default for osd_objectstore
> having changed between versions?  I think the "fix" is probably to pass
> '--osd-objecstore bluestore' or '--osd-objecstore filestore' to this
> command depending on which type of store was getting created?

Ok, so that would explain the mistery... because ceph-disk asks for
the OSD with an id of 0, in my case this OSD was created with
bluestore, and then
I am trying to create one with filestore!

This would still be a bug in ceph-disk since I am passing --filestore
in the invocation and it still goes out to check... but regardless I
will try to clarify in the docs why and when this would happen.

Thanks for clarifying Sage!

>
> sage
>
>
>  >
> > The ceph-deploy cluster returns a 'no' the ceph-ansible one returns a '=
yes'.
> >
> > The documentation doesn't seem to explain where or how to set/unset
> > this. The references to the flag itself are minimal, just mentioning
> > that the '--allows-journal' flag is to check if a journal is allowed
> > or not.
> >
> > How does one tell a cluster that a journal is allowed (or not)?
> >
> > I am happy to go and expand on the documentation to explain this a bit
> > even if it is for Luminous only since ceph-volume doesn't check this.
> >
> >

