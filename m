Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1776790DE
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2019 18:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbfG2Qaj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Jul 2019 12:30:39 -0400
Received: from mail-ed1-f51.google.com ([209.85.208.51]:40246 "EHLO
        mail-ed1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728792AbfG2Qaj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Jul 2019 12:30:39 -0400
Received: by mail-ed1-f51.google.com with SMTP id k8so59858677eds.7
        for <ceph-devel@vger.kernel.org>; Mon, 29 Jul 2019 09:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0A+fiT+RHGB4xOEN7V94jZiSA+9cADMZQP/Bk8C7xoY=;
        b=HVYYBP7mVKMvkXdFW1DyCxbo0cYwr1lE+ugx0UsSoZgCfYu7pZEM7aIm490QmCVKoD
         2zakrMJ2Sf/3OfabTUdqFRzcqtmKc44obnoq6Q6iAuvo+6DzozGYxn27tzMYRHIn1def
         eL4kuR9maMbrlKAyzyew6FR2zxP2eVBJYThAMgNsJZO6QNtS9jvqqAyqCTSKGh2Id0uP
         s1G8dYJwVt6r6vnn+W9ODp+5jgkot19pNYBLh23fFc5j9b8e0/z+oGZFPkN+OnITMl2k
         OTcjKhAG6En/82sNDTmC7eG2fR6VOZctfSJ/db+zJsRSC1jcpWSLVHDpX8mxef+6AwAT
         bADg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0A+fiT+RHGB4xOEN7V94jZiSA+9cADMZQP/Bk8C7xoY=;
        b=sU7Q1aZ/G7cFgR6wHGeqR1txeJqXlQ43WqlaAfXXVzsFULTLOJfCNVTQvk84KuOn1d
         MODUdXK3hQDZCHRYkWW6TCO/vcuFcAdrE+2WBEsdFNN1+Rsrfn0EgDEgv/C/maywDlSL
         L1JntE+3O+HrIDz0KADkmYzQ+pbewnjv6GcpZZCeMC1/Z5GixACeVgWy1GGR+tGy6/+k
         nw3EoLp4YeUy6bqA5BnXApyXxnaDKzoIM0Vwg15nsF8lWddiX7GByQvtPYJRpw2O15nD
         xhF6ev5XHu6mMMx/6TGyJlsy9ELTkv3EWcOAXNit2gEjBUwAwM12SgFaeLlzZqPT+Fr/
         sTdA==
X-Gm-Message-State: APjAAAVNhpzP3HrfzyJAxx22kVXCWPmxwh2+wT+4tdKHeU5iXw0BidVE
        MYWkECNhAzWb3DvVdve58w==
X-Google-Smtp-Source: APXvYqyBjLG32l4nxzi6zE3jdi+jfpaqseOkDm7EJDj0H/3Hvz0L4dyC+nZ7rJRsdmRSk1LYfhd9MA==
X-Received: by 2002:a17:906:2409:: with SMTP id z9mr39771676eja.179.1564417837952;
        Mon, 29 Jul 2019 09:30:37 -0700 (PDT)
Received: from localhost ([91.245.78.132])
        by smtp.gmail.com with ESMTPSA id cb19sm11681704ejb.51.2019.07.29.09.30.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 09:30:37 -0700 (PDT)
From:   Mykola Golub <to.my.trociny@gmail.com>
X-Google-Original-From: Mykola Golub <mgolub@suse.de>
Date:   Mon, 29 Jul 2019 19:30:36 +0300
To:     Ajitha Robert <ajitharobert01@gmail.com>
Cc:     ceph-users@lists.ceph.com, ceph-users@ceph.com,
        ceph-devel@vger.kernel.org
Subject: Re: [ceph-users] Error in ceph rbd
 mirroring(rbd::mirror::InstanceWatcher: C_NotifyInstanceRequestfinish:
 resending after timeout)
Message-ID: <20190729163035.GB8882@gmail.com>
References: <CAEbG6hG7dAhg=Z9JUKcCCTOEPyXZ6cZcS=jar7SeL-5VTcqEgA@mail.gmail.com>
 <20190726093147.GA31242@gmail.com>
 <CAEbG6hFgvWFMgaYHRRtZdth-OkJ7ib4vWxf__b7QvGPd1rF6Qg@mail.gmail.com>
 <20190726132546.GA6825@gmail.com>
 <CAEbG6hE1s=wJ7hGAPSiFee7iLu7QPrC-s4zDf1kZa3xMsVscdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEbG6hE1s=wJ7hGAPSiFee7iLu7QPrC-s4zDf1kZa3xMsVscdw@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, Jul 27, 2019 at 06:08:58PM +0530, Ajitha Robert wrote:

> *1) Will there be any folder related to rbd-mirroring in /var/lib/ceph ? *

no

> *2) Is ceph rbd-mirror authentication mandatory?*

no. But why are you asking?

> *3)when even i create any cinder volume loaded with glance image i get the
> following error.. *
> 
> 2019-07-27 17:26:46.762571 7f93eb0a5780 20 librbd::api::Mirror: peer_list:
> 2019-07-27 17:27:07.541701 7f939d7fa700  0 rbd::mirror::ImageReplayer:
> 0x7f93c800e9e0 [19/b6656be7-6006-4246-ba93-a49a220e33ce] handle_shut_down:
> remote image no longer exists: scheduling deletion
> 2019-07-27 17:27:16.766199 7f93eb0a5780 20 librbd::api::Mirror: peer_list:
> 2019-07-27 17:27:22.568970 7f939d7fa700  0 rbd::mirror::ImageReplayer:
> 0x7f93c800e9e0 [19/b6656be7-6006-4246-ba93-a49a220e33ce] handle_shut_down:
> mirror image no longer exists
> 2019-07-27 17:27:46.769158 7f93eb0a5780 20 librbd::api::Mirror: peer_list:
> 2019

The log tells that the primary image was deleted by some reason and
the rbd-mirror scheduled the secondary (mirrored) image deletion. From
the logs it is not seen why the primary image was deleted. It might be
sinder but can't exlude some bug in the rbd-mirror, running on the
primary cluster, though I don't recall any issues like this.

> *Attimes i can able to create bootable cinder volume apart from the above
> errors, but certain times i face the following
> 
> example, For a 50 gb volume, Local image get created, but it couldnt create
> a mirror image

"Connection timed out" errors suggest you have a connectivity issue
between sites?

-- 
Mykola Golub
