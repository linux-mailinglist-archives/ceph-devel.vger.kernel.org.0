Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36BC3A5F66
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Jun 2021 11:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbhFNJwn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Jun 2021 05:52:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23191 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232630AbhFNJwm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 05:52:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623664239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=ZIox7R38ipNJw+7XNJcu8xE04t1WpAGBKQqFbRCwaSEcakIwWILiX76t7awkQs5yp3Bl58
        Y6O4s4Mpl4ceeDyOLrOvMAXaXUpUwIEFR42HebN9a3qxiGeh3T8C8ZwKRY/Uno07OtvS9p
        dXLnjASd/XuUS9Dzxbr9CDXRSJBMfJI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-6K6ejBlqMLukwvB5SRA5QA-1; Mon, 14 Jun 2021 05:50:38 -0400
X-MC-Unique: 6K6ejBlqMLukwvB5SRA5QA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6A0E100C610;
        Mon, 14 Jun 2021 09:50:36 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-118-65.rdu2.redhat.com [10.10.118.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4F991007623;
        Mon, 14 Jun 2021 09:50:25 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20210613233345.113565-1-jlayton@kernel.org>
References: <20210613233345.113565-1-jlayton@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     dhowells@redhat.com, linux-cachefs@redhat.com, idryomov@gmail.com,
        willy@infradead.org, pfmeec@rit.edu, ceph-devel@vger.kernel.org,
        Andrew W Elble <aweits@rit.edu>
Subject: Re: [PATCH] netfs: fix test for whether we can skip read when writing beyond EOF
MIME-Version: 1.0
Content-Type: text/plain
Date:   Mon, 14 Jun 2021 10:50:24 +0100
Message-ID: <319722.1623664224@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

