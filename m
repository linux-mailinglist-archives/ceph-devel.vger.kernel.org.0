Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7723BB674
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jul 2021 06:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhGEEkG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Jul 2021 00:40:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28986 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229447AbhGEEkG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 5 Jul 2021 00:40:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625459849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lsCDhuHpVhEXTOG/i4oKlRRqNRJq9ILBx91Xxwn+o2Y=;
        b=JUCdBupqWLZH3BwU4G5YnwemQtLZbt3C6WLffTs8K+35WeH+uWuiUzy7FWQRXjWnlPOoEE
        hkwRYZVzTqXhUYOp6zoKj/RyqdAMKxV1qRQvK42/1tb2DODMyJsvcSdTjsAog4Ybsp44rV
        QCyYYjG72CO8LgHWnXgvIB75Rc7Y95M=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-OE55PT2MMq2aBlo_47gRaw-1; Mon, 05 Jul 2021 00:37:28 -0400
X-MC-Unique: OE55PT2MMq2aBlo_47gRaw-1
Received: by mail-ed1-f71.google.com with SMTP id cn11-20020a0564020cabb0290396d773d4c7so3627943edb.18
        for <ceph-devel@vger.kernel.org>; Sun, 04 Jul 2021 21:37:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lsCDhuHpVhEXTOG/i4oKlRRqNRJq9ILBx91Xxwn+o2Y=;
        b=caLuX9pn/Agx+xxfMnKfh7Edw6nZWw1uOzleTomXDwkhZLoN0I6oYEOBZdY6yPQxiD
         Hz72+visLFXPicPucIKUxLi+r9I82CzPVOA47WLlM4gZ+QNCrb/+TwhwcfFYeU4EfKOz
         E5OuFBrm136V0Xd0Cxul7eVXfGu5N70P1jgkQrJcT1jF29i8QKeIj5mxsduwLsTQwOzW
         zm1L6IAHI4x2GM10uDcwKyqOoIX949s2qR3LTr7WVYvaA2ChBTmKM7DDs4fFLNm9kf9S
         F6kowvqDDAFIvFZOgLN5pFgwKE+Gm+LdkUcnUAG+UfL8YQftOV6saZ3ZwrD2kas6YbUd
         BZCA==
X-Gm-Message-State: AOAM533NxvngD2DmMa2ugVepBQ3vnA4zy+ISgoiCbCe6Z/pjcnmYefsP
        a5Zphz46/wX4ArXMTEtGqJnDfVPbG+uXsjNIriuqg93bAQds3c5ofAvyXp7ojXButxKolAAJmiF
        pb8KnF5dD/PXSQHlnmbJ6RG0GSNoKQbEdWxYedA==
X-Received: by 2002:a17:907:2ce1:: with SMTP id hz1mr810590ejc.198.1625459847716;
        Sun, 04 Jul 2021 21:37:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQl02Rs54czfd/iCyzybASk985KGvx0unkXNN/blH1c4Oom62er8+lYG9hm0TXehlaWQ7iNzXPDbYo2aJXgGs=
X-Received: by 2002:a17:907:2ce1:: with SMTP id hz1mr810577ejc.198.1625459847599;
 Sun, 04 Jul 2021 21:37:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210702064821.148063-1-vshankar@redhat.com> <CA+2bHPbxR94_Bc-C5Ly7HQvwQPsoBr-j+fomGkTcBM5=8aS=0g@mail.gmail.com>
In-Reply-To: <CA+2bHPbxR94_Bc-C5Ly7HQvwQPsoBr-j+fomGkTcBM5=8aS=0g@mail.gmail.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Mon, 5 Jul 2021 10:06:51 +0530
Message-ID: <CACPzV1=3N2mv3Je+decqNAbi0z5vPTDWMnrV7vpB+TDrwhWwnw@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] ceph: new mount device syntax
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     Jeff Layton <jlayton@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Luis Henriques <lhenriques@suse.de>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jul 2, 2021 at 11:36 PM Patrick Donnelly <pdonnell@redhat.com> wrote:
>
> On Thu, Jul 1, 2021 at 11:48 PM Venky Shankar <vshankar@redhat.com> wrote:
> > Also note that the userspace mount helper tool is backward
> > compatible. I.e., the mount helper will fallback to using
> > old syntax after trying to mount with the new syntax.
>
> The kernel is also backwards compatible too, right?

Yes.

>
> --
> Patrick Donnelly, Ph.D.
> He / Him / His
> Principal Software Engineer
> Red Hat Sunnyvale, CA
> GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
>


-- 
Cheers,
Venky

