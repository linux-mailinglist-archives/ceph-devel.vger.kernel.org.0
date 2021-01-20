Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADCD2FDA5A
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Jan 2021 21:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392914AbhATUFL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Jan 2021 15:05:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:38384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388042AbhATUEv (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 20 Jan 2021 15:04:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1505223440;
        Wed, 20 Jan 2021 20:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611173045;
        bh=ng4M7Czgxg2lkme6eEmSHve4psVHOKROYyjsZPTsnLM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=e8vJeS7LsznX5ZAy1BIHkEoNbMOGgr/HxHTOMsyTzZvPkA12sDE/N1jxOyKZOaheT
         jGVRCgNE8x2vHbYr75pwuATjvFIW1kZU4rRUjJKATZ0Lje4Kv6HI9t5BqlDDO+PIlQ
         ePMShTB/lFPv5G69BFt4sx792O4n8EC0j/TronQOn/PxjmNT9/IJ5pd4FGs8C5zSJk
         P9T3jL1/4I/pVTxykDFVWB65JJCiKqUgtNIAbaI2Qscm0Qkm310nUDMkNfwzFDKDv8
         QPFguBQgVol5Rn3aNTUV3uRijDDujEB85YETAmLci8SMILjQJB5wPFpu1wb01IrlAq
         PFaAWKJLOWtJg==
Message-ID: <18bc5695b7f2c1f7f18fe8307bde30e5ae0c1b5a.camel@kernel.org>
Subject: Re: [PATCH v3] ceph: defer flushing the capsnap if the Fb is used
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 20 Jan 2021 15:04:03 -0500
In-Reply-To: <d05c2108-079d-f9c4-7a65-2be42579ecbb@redhat.com>
References: <20210110020140.141727-1-xiubli@redhat.com>
         <f698d039251d444eec334b119b5ae0b0dd101a21.camel@kernel.org>
         <376245cf-a60d-6ddb-6ab3-894a491b854e@redhat.com>
         <5a6fd5f3ab30fe04332bc4af4ecdeaca7fd501c0.camel@kernel.org>
         <d05c2108-079d-f9c4-7a65-2be42579ecbb@redhat.com>
Content-Type: multipart/mixed; boundary="=-qgHbl+V+EgDzCFCSofCE"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


--=-qgHbl+V+EgDzCFCSofCE
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 8bit

On Wed, 2021-01-20 at 08:56 +0800, Xiubo Li wrote:
> On 2021/1/18 19:08, Jeff Layton wrote:
> > On Mon, 2021-01-18 at 17:10 +0800, Xiubo Li wrote:
> > > On 2021/1/13 5:48, Jeff Layton wrote:
> > > > On Sun, 2021-01-10 at 10:01 +0800, xiubli@redhat.com wrote:
> > > > > From: Xiubo Li <xiubli@redhat.com>
> > > > > 
> > > > > If the Fb cap is used it means the current inode is flushing the
> > > > > dirty data to OSD, just defer flushing the capsnap.
> > > > > 
> > > > > URL: https://tracker.ceph.com/issues/48679
> > > > > URL: https://tracker.ceph.com/issues/48640
> > > > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > > > ---
> > > > > 
> > > > > V3:
> > > > > - Add more comments about putting the inode ref
> > > > > - A small change about the code style
> > > > > 
> > > > > V2:
> > > > > - Fix inode reference leak bug
> > > > > 
> > > > > Â Â fs/ceph/caps.c | 32 +++++++++++++++++++-------------
> > > > > Â Â fs/ceph/snap.c |  6 +++---
> > > > > Â Â 2 files changed, 22 insertions(+), 16 deletions(-)
> > > > > 
> > > > Hi Xiubo,
> > > > 
> > > > This patch seems to cause hangs in some xfstests (generic/013, in
> > > > particular). I'll take a closer look when I have a chance, but I'm
> > > > dropping this for now.
> > > Okay.
> > > 
> > > BTW, what's your test commands to reproduce it ? I will take a look when
> > > I am free these days or later.
> > > 
> > > BRs
> > > 
> > I set up xfstests to run on cephfs, and then just run:
> > 
> >      $ sudo ./check generic/013
> > 
> > It wouldn't reliably complete with this patch in place. Setting up
> > xfstests is the "hard part". I'll plan to roll up a wiki page on how to
> > do that soon (that's good info to have out there anyway).
> 
> Okay, sure.
> 

I'm not sure where this should be documented. Still, here's a
local.config that I'm using now (with comments). I'm happy to merge this
somewhere for posterity, but not sure where it should go.

-- 
Jeff Layton <jlayton@kernel.org>

--=-qgHbl+V+EgDzCFCSofCE
Content-Disposition: attachment; filename="kcephfs.config"
Content-Type: text/plain; name="kcephfs.config"; charset="ISO-8859-15"
Content-Transfer-Encoding: base64

IwojIEZvciBydW5uaW5nIHhmc3Rlc3RzIG9uIGtjZXBoZnMKIwojIEluIHRoaXMgZXhhbXBsZSwg
d2UndmUgY3JlYXRlZCB0d28gZGlmZmVyZW50IG5hbWVkIGZpbGVzeXN0ZW1zOiAidGVzdCIKIyBh
bmQgInNjcmF0Y2guIFRoZXkgbXVzdCBiZSBwcmUtY3JlYXRlZCBvbiB0aGUgY2VwaCBjbHVzdGVy
IGJlZm9yZSB0aGUKIyB0ZXN0IGlzIHJ1bi4KIwojIFN0YW5kYXJkIG1vdW50cG9pbnQgbG9jYXRp
b25zIGFyZSBmaW5lCiMKZXhwb3J0IFRFU1RfRElSPS9tbnQvdGVzdApleHBvcnQgU0NSQVRDSF9N
TlQ9L21udC9zY3JhdGNoCgojCiMgImNoZWNrIiBjYW4ndCBhdXRvbWF0aWNhbGx5IGRldGVjdCBj
ZXBoIGRldmljZSBzdHJpbmdzLCBzbyB3ZSBtdXN0CiMgZXhwbGljaXRseSBkZWNsYXJlIHRoYXQg
d2Ugd2FudCB0byB1c2UgIi10IGNlcGgiLgojCmV4cG9ydCBGU1RZUD1jZXBoCgojCiMgVGhlIGNo
ZWNrIHNjcmlwdCBnZXRzIHZlcnkgY29uZnVzZWQgd2hlbiB0d28gZGlmZmVyZW50IG1vdW50cyB1
c2UKIyB0aGUgc2FtZSBkZXZpY2Ugc3RyaW5nLiBFdmVudHVhbGx5IHdlIG1heSBmaXggdGhpcyBp
biBjZXBoIHNvIHdlIGNhbgojIGdldCBtb25hZGRycyBmcm9tIHRoZSBjb25maWcsIGJ1dCBmb3Ig
bm93LCB3ZSBtdXN0IGRlY2xhcmUgdGhlIGxvY2F0aW9uCiMgb2YgdGhlIG1vbnMgZXhwbGljaXRs
eS4gTm90ZSB0aGF0IHdlJ3JlIHVzaW5nIHR3byBkaWZmZXJlbnQgbW9uYWRkcnMKIyBoZXJlLCB0
aG91Z2ggdGhlc2UgYXJlIHVzaW5nIHRoZSBzYW1lIGNsdXN0ZXIuIFRoZSBtb25hZGRycyBtdXN0
IGFsc28KIyBtYXRjaCB0aGUgdHlwZSBvZiBtc19tb2RlIG9wdGlvbiB0aGF0IGlzIGluIGVmZmVj
dCAoaS5lLgojIG1zX21vZGU9bGVnYWN5IHJlcXVpcmVzIHYxIG1vbmFkZHJzKS4KIwpleHBvcnQg
VEVTVF9ERVY9MTAuMTAuMTAuMTozMzAwOi8KZXhwb3J0IFNDUkFUQ0hfREVWPTEwLjEwLjEwLjI6
MzMwMDovCgojCiMgVEVTVF9GU19NT1VOVF9PUFRTIGlzIGZvciAvbW50L3Rlc3QsIGFuZCBNT1VO
VF9PUFRPTlMgaXMgZm9yIC9tbnQvc2NyYXRjaAojCiMgSGVyZSwgd2UncmUgdXNpbmcgdGhlIGFk
bWluIGFjY291bnQgZm9yIGJvdGggbW91bnRzLiBUaGUgY3JlZGVudGlhbHMKIyBzaG91bGQgYmUg
aW4gYSBzdGFuZGFyZCBrZXlyaW5nIGxvY2F0aW9uIHNvbWV3aGVyZS4gU2VlOgojCiMgaHR0cHM6
Ly9kb2NzLmNlcGguY29tL2VuL2xhdGVzdC9yYWRvcy9vcGVyYXRpb25zL3VzZXItbWFuYWdlbWVu
dC8ja2V5cmluZy1tYW5hZ2VtZW50CiMKQ09NTU9OX09QVElPTlM9Im5hbWU9YWRtaW4sbXNfbW9k
ZT1jcmMiCgojCiMgYXN5bmNyb25vdXMgZGlyZWN0b3J5IG9wcwojCkNPTU1PTl9PUFRJT05TKz0i
LG5vd3N5bmMiCgojCiMgc3dpenpsZSBpbiB0aGUgQ09NTU9OX09QVElPTlMKIwpURVNUX0ZTX01P
VU5UX09QVFM9Ii1vICR7Q09NTU9OX09QVElPTlN9LG1kc19uYW1lc3BhY2U9dGVzdCIKTU9VTlRf
T1BUSU9OUz0iLW8gJHtDT01NT05fT1BUSU9OU30sbWRzX25hbWVzcGFjZT1zY3JhdGNoIgoKIwoj
IGZzY2FjaGUgLS0gdGhpcyBuZWVkcyBhIGRpZmZlcmVudCBvcHRpb24gZm9yIGVhY2gKIwojIFRF
U1RfRlNfTU9VTlRfT1BUUys9Iixmc2M9dGVzdCIKIyBNT1VOVF9PUFRJT05TKz0iLGZzYz1zY3Jh
dGNoIgoKZXhwb3J0IFRFU1RfRlNfTU9VTlRfT1BUUwpleHBvcnQgTU9VTlRfT1BUSU9OUwo=


--=-qgHbl+V+EgDzCFCSofCE--

