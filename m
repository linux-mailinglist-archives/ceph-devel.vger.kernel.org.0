Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E21F1C435A
	for <lists+ceph-devel@lfdr.de>; Mon,  4 May 2020 19:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730447AbgEDRym (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 4 May 2020 13:54:42 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58033 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730427AbgEDRyl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 4 May 2020 13:54:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588614879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+o4SdY0w3UouF91y2gLQuR1sVRgD2BPdPwIappEYt/U=;
        b=T2mGk/HhnGz7gXrVP24P2iHgVVzdLEthQ+KdwC5Hq6IOPAxLxbrxnEWQopCszU0KA3Tu18
        f+FCoES1x8vibsZ6vh3JODelZbI5/Gxt0zzidw18XNkhzillnjPRNUN58XIwZWE6LNkW8k
        Y/LK5gsJrJZP/0RU5tjMMzVrjcTFMvg=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332--J-EwTxvPiCeNgr-_TuNwQ-1; Mon, 04 May 2020 13:54:36 -0400
X-MC-Unique: -J-EwTxvPiCeNgr-_TuNwQ-1
Received: by mail-qt1-f200.google.com with SMTP id q43so380357qtj.11
        for <ceph-devel@vger.kernel.org>; Mon, 04 May 2020 10:54:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=+o4SdY0w3UouF91y2gLQuR1sVRgD2BPdPwIappEYt/U=;
        b=MjQrQHorzoL5t3vqyIMEOGzIH9My6xYNrvwoTtkR5nYrIFbbAkkwzPVIGTudIIqJMr
         31VBYy/K6XpcgL/kDwWrg065cREDBNEPFUVJpq/MG4Sn8B/aVGsIQ+CodAGFS4HUBUgA
         yJn/jfcoggeKAhUsqHRbfMi/V3fl7P+4pTGJ0G8ZXGBet01so4PmJAuoret67UzJvv3/
         5NFb/ByN4TyQLKTMtBh15ZiPxyU74ol+BSHlG6imz55CFtO6fsjHBntQT+MqXKxa6kUQ
         lSrOl/kqj2TnpoWdu8BZresQVBninLj56BRISPrvaFC9VXLqYuFLs+iXjmiiSqSIOsLs
         SsPw==
X-Gm-Message-State: AGi0PuaF9lMayzZab3Wh4tLCAitCFD28kJ84uHF++F4S3iv/qWqWe1uq
        fwvA1dzwyZsB4WzTwWv6XPMMIewB9934RHkD54WBA4puGD8fU1RTl6zgvYdDDpRKfLilxNXFMD+
        hXEKUDEKajc9DaaW3fo4/4g==
X-Received: by 2002:a05:620a:7ca:: with SMTP id 10mr370212qkb.131.1588614875626;
        Mon, 04 May 2020 10:54:35 -0700 (PDT)
X-Google-Smtp-Source: APiQypK3uCi6lFkdGRP90/JqMNVl2EPo4jU4+vUXICbUKWh5Z7zHzwK3PWjYZaZSl3+osjCddPgO1g==
X-Received: by 2002:a05:620a:7ca:: with SMTP id 10mr370193qkb.131.1588614875436;
        Mon, 04 May 2020 10:54:35 -0700 (PDT)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id q32sm12123066qta.13.2020.05.04.10.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 10:54:34 -0700 (PDT)
Message-ID: <63498a6eedc7994b1e96a59d12468bfd15e15ef4.camel@redhat.com>
Subject: Re: [RFC PATCH 00/61] fscache, cachefiles: Rewrite the I/O
 interface in terms of kiocb/iov_iter
From:   Jeff Layton <jlayton@redhat.com>
To:     David Howells <dhowells@redhat.com>,
        Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-afs@lists.infradead.org, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, ceph-devel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 04 May 2020 13:54:33 -0400
In-Reply-To: <158861203563.340223.7585359869938129395.stgit@warthog.procyon.org.uk>
References: <158861203563.340223.7585359869938129395.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-05-04 at 18:07 +0100, David Howells wrote:
> 
>  (3) Make NFS, CIFS, Ceph, 9P work with it.  I'm hoping that Jeff Layton will
>      do Ceph.  As mentioned, I'm having a crack at NFS, but it's evolved a bit
>      since I last looked at it and it might be easier if I can palm that off
>      to someone more current in the NFS I/O code.
> 
> 

[...]

This looks like a really nice overhaul. I particularly love the
diffstat. Net removal of ~4000 lines!

I'll plan to draft up a patch for Ceph in the near future. The new API
seems to be quite different, so I imagine this will more or less be a
rip and replace on the old code.
-- 
Jeff Layton <jlayton@redhat.com>

