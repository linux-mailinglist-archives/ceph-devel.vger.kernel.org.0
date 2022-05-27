Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48424535806
	for <lists+ceph-devel@lfdr.de>; Fri, 27 May 2022 05:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238293AbiE0DYE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 26 May 2022 23:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiE0DYD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 26 May 2022 23:24:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7F4EB6157
        for <ceph-devel@vger.kernel.org>; Thu, 26 May 2022 20:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653621840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CNB6nm9imnMhEWbze1yFT3zEAHFqyZg1VlwYfSvOk60=;
        b=W5CLzHbehrmYxKdNm/vayEP0/yN8b3nOfsiUhhgo2FgNj3bVFqBHQxhiIMWYFHT/DcREsf
        ShoV6koBYXLdRd9zr0mKIYHwQb19l4EG0ps0l6edo0f0qDNrPdVE8JmGJDnsARsGBrTEju
        BpC5YaAOyFAmPx1sI+G3KUI95EMfyuw=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-59-dGOHaFn4NAeaMa6auxxwWA-1; Thu, 26 May 2022 23:23:57 -0400
X-MC-Unique: dGOHaFn4NAeaMa6auxxwWA-1
Received: by mail-lf1-f72.google.com with SMTP id x36-20020a056512132400b0044b07b24746so1428672lfu.8
        for <ceph-devel@vger.kernel.org>; Thu, 26 May 2022 20:23:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CNB6nm9imnMhEWbze1yFT3zEAHFqyZg1VlwYfSvOk60=;
        b=tm53YPQtXwLq/nFnPu02gF4iSkLosPW2mtByKee+92E9rsfSYP9xJH9wP0fTZ5tB9Z
         N0jRJjmHbViQvqKm3LwhJOuJNBNvU92ww1dVw8twg4fuA3BXN4Ub+0VymJ5dRRyBI0yB
         8jZ9RcRHT6WFLH/kRmNg5Qw8GVRXsheIBFh8n7wy/aZO+mqrR3Bs24U+imNKGw7COk2o
         5phUvQADQRPVNv5cDDTn0a1mgZPMcvZZoD1HIciE9ufEdbhykB3UPjUd7vo9B3If/NPq
         GmGgRPYJHD1uycDHaJxMHoyk3xYvd473qu3CirB7qMRsZaMz1u3P1DUBYgSa5OZ17EW0
         zAHw==
X-Gm-Message-State: AOAM533no+gjrdOZBXOzGs0FXubvfAZlR7puFWRlOLYTm9z0pe58z6bB
        tNi7eTQHYc8qHNKE6cIm0Cz4t9UsbmJkKKC3YXtlAR4L/25jBqqLSKI1DPFO9Fjq/1WAuVCw478
        8eitpy4uahf0iPTtKL9435ZdUoP7keN5atSgjlQ==
X-Received: by 2002:a2e:5cc1:0:b0:24b:112f:9b36 with SMTP id q184-20020a2e5cc1000000b0024b112f9b36mr24329266ljb.337.1653621836119;
        Thu, 26 May 2022 20:23:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzq3AlLTRcpnjnf5ISdbmeT1DeOP1a/lGEm/pg7/4+6KtuWTkqiDk1gciDqLWDM7rD1v++15SIHQAin5xa37y4=
X-Received: by 2002:a2e:5cc1:0:b0:24b:112f:9b36 with SMTP id
 q184-20020a2e5cc1000000b0024b112f9b36mr24329245ljb.337.1653621835775; Thu, 26
 May 2022 20:23:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220525172427.3692-1-lhenriques@suse.de> <fb3d817d8b6235472e517a9fc9ad0956fb4e8cf2.camel@kernel.org>
 <3cb96552-9747-c6b4-c8d3-81af60e5ae6a@redhat.com> <ca4928507bdf329bbe5b32a7b71f4a4295e5bba1.camel@kernel.org>
 <f238e4a1-ef98-ccfe-6345-51b6d9a34319@redhat.com>
In-Reply-To: <f238e4a1-ef98-ccfe-6345-51b6d9a34319@redhat.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Thu, 26 May 2022 20:23:39 -0700
Message-ID: <CAJ4mKGZyw+uKjwkSBseETtKXwJOSV2D8J9mLH-8yB8w98Ow=fA@mail.gmail.com>
Subject: Re: [RFC PATCH v2] ceph: prevent a client from exceeding the MDS
 maximum xattr size
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        =?UTF-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, May 26, 2022 at 6:10 PM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 5/27/22 8:44 AM, Jeff Layton wrote:
> > On Fri, 2022-05-27 at 08:36 +0800, Xiubo Li wrote:
> >> On 5/27/22 2:39 AM, Jeff Layton wrote:
> >>> A question:
> >>>
> >>> How do the MDS's discover this setting? Do they get it from the mons?=
 If
> >>> so, I wonder if there is a way for the clients to query the mon for t=
his
> >>> instead of having to extend the MDS protocol?
> >> It sounds like what the "max_file_size" does, which will be recorded i=
n
> >> the 'mdsmap'.
> >>
> >> While currently the "max_xattr_pairs_size" is one MDS's option for eac=
h
> >> daemon and could set different values for each MDS.
> >>
> >>
> > Right, but the MDS's in general don't use local config files. Where are
> > these settings stored? Could the client (potentially) query for them?
>
> AFAIK, each process in ceph it will have its own copy of the
> "CephContext". I don't know how to query all of them but I know there
> have some API such as "rados_conf_set/get" could do similar things.
>
> Not sure whether will it work in our case.
>
> >
> > I'm pretty sure the client does fetch and parse the mdsmap. If it's
> > there then it could grab the setting for all of the MDS's at mount time
> > and settle on the lowest one.
> >
> > I think a solution like that might be more resilient than having to
> > fiddle with feature bits and such...
>
> Yeah, IMO just making this option to be like the "max_file_size" is more
> appropriate.

Makes sense to me =E2=80=94 this is really a property of the filesystem, no=
t a
daemon, so it should be propagated through common filesystem state.
I guess Luis' https://github.com/ceph/ceph/pull/46357 should be
updated to do it that way? I see some discussion there about handling
old clients which don't recognize these limits as well.
-Greg

