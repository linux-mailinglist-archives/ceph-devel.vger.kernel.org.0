Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B992649B571
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jan 2022 14:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383653AbiAYN4i (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jan 2022 08:56:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58194 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353962AbiAYNye (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 25 Jan 2022 08:54:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643118872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8VkriMqXxVWR4GtJa95D1EAxudZBv0qG2Rw5kozi+vM=;
        b=LBTbxmuR3GYvW2J2y2PM3LpWmivn6c0IGawZrV4lrfdxZ5wEMhuVMPFWFucWpRJapzqPrU
        i7n1Eq2rNypWLvrk+DybiPX/+B+GLGhU1F6yuEPypQOEY/H7r1ef91z1QZ4YW5FgPLvlZL
        xJbm8CrzYAXzE0JUdERb39r/jNxiCJo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-JU_qenHAM2GCMGkhLTsgMQ-1; Tue, 25 Jan 2022 08:54:26 -0500
X-MC-Unique: JU_qenHAM2GCMGkhLTsgMQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D5209251D;
        Tue, 25 Jan 2022 13:54:25 +0000 (UTC)
Received: from horse.redhat.com (unknown [10.22.9.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D879C7BB62;
        Tue, 25 Jan 2022 13:54:24 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 6035B223DA6; Tue, 25 Jan 2022 08:54:24 -0500 (EST)
Date:   Tue, 25 Jan 2022 08:54:24 -0500
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Paul Moore <paul@paul-moore.com>, Stephen Muth <smuth4@gmail.com>,
        ceph-devel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: "kernel NULL pointer dereference" crash when attempting a write
Message-ID: <YfABEFlldUTHL+BH@redhat.com>
References: <CAM2jsSiHK_++SggmRyRbCxZ58hywxeZsJJMJHpQfbAz-5AfJ0g@mail.gmail.com>
 <CAHC9VhR1efuTR_zLLhmOyS4EHT1oHgA1d_StooKXmFf9WGODyA@mail.gmail.com>
 <a77ca75bfb69f527272291b4e6556fc46c37f9df.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a77ca75bfb69f527272291b4e6556fc46c37f9df.camel@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jan 25, 2022 at 05:54:57AM -0500, Jeff Layton wrote:

[..]
> -	/*
> -	 * FIXME: Make security_dentry_init_security() generic. Currently
> -	 * It only supports single security module and only selinux has
> -	 * dentry_init_security hook.
> -	 */

I think this comment is still very valid. security_dentry_init_security()
still supports only single security module. It does not have the
capability to deal with two modules trying to return security context.

All my patch did was that instead of SELinux, now another LSM could
return security context and also return xattr name for the security
context. But it did nothing to allow multiple LSMs to return their
own security contexts.

IMHO, this FIXME should still be there and not removed. 

Thanks
Vivek

