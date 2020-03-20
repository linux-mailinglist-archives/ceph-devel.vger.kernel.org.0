Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8CE18D2DA
	for <lists+ceph-devel@lfdr.de>; Fri, 20 Mar 2020 16:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgCTP0U (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 20 Mar 2020 11:26:20 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:32657 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726847AbgCTP0T (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 20 Mar 2020 11:26:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584717978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X3Z6uNArOMy1eWk31fBWdvBKZKMNXZROFwUGlya3yhI=;
        b=fRIyMXP5sOwoFhlrBduqzWNE+89hPWfPraaR9ckF/IDEtFFnEDt9Ken3GOnO1wYKPpFJzr
        xjHTElYmf9IUnFJgu+p6tL5VpdczfhOKWXPONX2awXqMP5TY9PG8pPywfzCUTw/8RctiFF
        hrE3aFrWEAlAh34u4WMcrsECok7Zags=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-E9N_NLSiNPmf3TCCLGmDNA-1; Fri, 20 Mar 2020 11:26:17 -0400
X-MC-Unique: E9N_NLSiNPmf3TCCLGmDNA-1
Received: by mail-qv1-f71.google.com with SMTP id ev8so6058357qvb.1
        for <ceph-devel@vger.kernel.org>; Fri, 20 Mar 2020 08:26:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=X3Z6uNArOMy1eWk31fBWdvBKZKMNXZROFwUGlya3yhI=;
        b=LRycEOnwWDyJ+Bu1ZCfkLqTYhoHUbvsCYt6jMFqsrjKNaioHPNTm7BJl6DQCu7YxZi
         pk0bjAr4ANEyCedamD2XmLor6VPkHESbIvvTcqw+hiDWbzl0KCZcYpZT7r4WhmtZqNC/
         C+gE7A5xvrIH8A166a4YfPZUtkMk7wcs7tKQzMsyZN72iOfNa8Ktrn16I/gs6nU1Okb2
         K/R/r73emuSTNQfrd6xRc4bDo2wubPq9qJ4qNsjnXqz0ntI4hNAQ1afTKyzlimE/qEr1
         NlWJk6U0G0rjULAolb+J/6Y3DXilRHz3GhpvSu2nErPPf22wwanArbFB95JHlvizfqtJ
         oOKg==
X-Gm-Message-State: ANhLgQ08OdRco3HkronWG6eJFyira5XzDRGQRv52fWicV1PkXs32VcIR
        mao6xjwu1OfB03Te67REzLrYu+58HtG8BZ4lZh0qKWQ49EYP9Isvv5y3yG2TVfUmp3MCPWZtXQE
        RZe1zs2zs7praQnsghzpJmg==
X-Received: by 2002:ae9:e407:: with SMTP id q7mr8929395qkc.206.1584717976511;
        Fri, 20 Mar 2020 08:26:16 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtXkdDbA9qtAK/qaIj1FTAJNkInlC3jk1/0DCQIkGQNnXmCzh9R3/ltPjp+iwNsiGDGFmgVGw==
X-Received: by 2002:ae9:e407:: with SMTP id q7mr8929367qkc.206.1584717976206;
        Fri, 20 Mar 2020 08:26:16 -0700 (PDT)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id g9sm3766189qka.66.2020.03.20.08.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 08:26:15 -0700 (PDT)
Message-ID: <407b958e768145625d6c58a2c09392539bf07144.camel@redhat.com>
Subject: Re: extend cephadm to do minimal client setup for kcephfs (and
 maybe krbd)?
From:   Jeff Layton <jlayton@redhat.com>
To:     Sage Weil <sage@newdream.net>
Cc:     "dev@ceph.io" <dev@ceph.io>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Fri, 20 Mar 2020 11:26:15 -0400
In-Reply-To: <alpine.DEB.2.21.2003201502120.21681@piezo.novalocal>
References: <833eb05d54ca8338843566a1fce9afee9283bdb2.camel@redhat.com>
         <alpine.DEB.2.21.2003201502120.21681@piezo.novalocal>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-03-20 at 15:04 +0000, Sage Weil wrote:
> On Fri, 20 Mar 2020, Jeff Layton wrote:
> > I've had this PR sitting around for a while:
> > 
> >     https://github.com/ceph/ceph/pull/31885
> > 
> > It's bitrotted a bit, and I'll clean that up soon, but after looking
> > over cephadm, I wonder if it would make sense to also extend it to do
> > these actions on machines that are just intended to be kcephfs or krbd
> > clients.
> 
> If you could just adjust this PR to update doc/cephadm/client-setup.rst or 
> similar instead, that would be great.  We plan to delete the ceph-deploy 
> section of the docs entirely Real Soon Now.
> 

Done. Still waiting on the doc render though to make sure it looks ok.

> > We typically don't need to do a full-blown install on the clients, so
> > being able to install just the minimum packages needed and do a minimal
> > conf/keyring setup would be nice.
> > 
> > Does this make sense? I'll open a tracker if the principal cephadm devs
> > are OK with it.
> 
> With cephadm, you can do this with
> 
>  # curl ....
>  # sudo ./cephadm add-repo --release octopus
>  # sudo ./cephadm install ceph-common
> 
> without having to think about which distro you're using.
> 
> Eventually we might want to teach cephadm how to manage the host-side 
> packages on certain hosts so that it keeps ceph.conf and client package(s) 
> up to date, but that needs some design thinking first... until then, 
> having simple docs would be great!

I'm mostly interested in making it super easy to set up a new client
machine to do a mount or krbd setup. Keeping it all updated would be
bonus of course, but the initial setup is the real pain point I think.

For that, it would be really nice to be able to just run "cephadm
client-setup" and have it do everything needed. Should we be looking to
cephadm for that or is it sort of out of scope of that project since
it's really geared toward managing the server-side cluster?

-- 
Jeff Layton <jlayton@redhat.com>

